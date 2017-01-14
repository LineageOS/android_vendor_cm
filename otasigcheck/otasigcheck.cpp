/*
 * Copyright (C) 2017 The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <fstream>
#include <iostream>
#include <regex>
#include <tinyxml2.h>

static const char *RELEASE_PACKAGE_NAME = "com.android.htmlviewer";
static const char *RELEASE_KEY_PATH = "/tmp/releasekey";

static const char *PACKAGES_XML_PATH = "/data/system/packages.xml";
static const char *PACKAGES_XML_BACKUP_PATH = "/data/system/packages-backup.xml";

static const char *RECOVERY_LOG = "/tmp/recovery.log";
static const char *WIPE_COMMAND_REGEX = "Command:.*\"--wipe_data\"";

static const int ABORT_EXIT_CODE = 124;

int main()
{
    std::ifstream recoveryLog(RECOVERY_LOG);
    if (recoveryLog.is_open()) {
        std::string logLine;
        std::regex wipeRegex(WIPE_COMMAND_REGEX);
        while (std::getline(recoveryLog, logLine)) {
            if (std::regex_match(logLine, wipeRegex)) {
                std::cout << "Data will be wiped after install; skipping signature check..." << std::endl;
                return 0;
            }
        }
    }

    std::ifstream releaseKeyFile(RELEASE_KEY_PATH);
    if (!releaseKeyFile.is_open()) {
        std::cout << "Could not open releasekey; skipping signature check..." << std::endl;
        return 0;
    }

    tinyxml2::XMLDocument packages;
    if (packages.LoadFile(PACKAGES_XML_BACKUP_PATH)) {
        if (packages.LoadFile(PACKAGES_XML_PATH)) {
            return 0;
        }
    }

    std::string releaseKey;
    std::getline(releaseKeyFile, releaseKey);
    if (releaseKey.empty()) {
        std::cout << "Invalid releasekey; skipping signature check..." << std::endl;
        return 0;
    }

    /*
     * Get the value of 'index' of the <cert> with RELEASE_PACKAGE_NAME as
     * 'name', find the <cert> with the same 'index' and a 'key' attribute,
     * and compare the found 'key' with /tmp/releasekey.
     *
     * Simplified tree structure:
     * <packages>
     *     <package name="some.package">
     *         <sigs count="1">
     *             <cert index="0" key="XXX" />
     *         </sigs>
     *     </package>
     *     <package name="RELEASE_PACKAGE_NAME">
     *         <sigs count="1">
     *             <cert index="0" />
     *         </sigs>
     *     </package>
     * </packages>
     */

    int certIndex;
    bool certIndexFound = false;
    int packageCertIndex;
    bool packageCertIndexFound = false;

    tinyxml2::XMLElement *root = packages.FirstChildElement("packages");
    if (!root) {
        std::cout << "Unknown xml structure; skipping signature check..." << std::endl;
        return 0;
    }

    for (tinyxml2::XMLElement *package = root->FirstChildElement("package");
            package != NULL; package = package->NextSiblingElement("package")) {

        tinyxml2::XMLElement *sigs = package->FirstChildElement("sigs");
        if (!sigs) {
            continue;
        }
        tinyxml2::XMLElement *cert = sigs->FirstChildElement("cert");
        if (!cert) {
            continue;
        }

        const char *key = cert->Attribute("key");
        if (key && !std::strcmp(key, releaseKey.c_str())) {
            cert->QueryIntAttribute("index", &certIndex);
            certIndexFound = true;
        }

        const char *packageName = package->Attribute("name");
        if (!packageCertIndexFound && packageName &&
                !std::strcmp(packageName, RELEASE_PACKAGE_NAME)) {
            cert->QueryIntAttribute("index", &packageCertIndex);
            packageCertIndexFound = true;
        }

        if (packageCertIndexFound && certIndexFound) {
            if (packageCertIndex != certIndex) {
                std::cout << "You have an installed system that isn't signed with this build's key, aborting..." << std::endl;
                return ABORT_EXIT_CODE;
            } else {
                return 0;
            }
        }
    }

    if (!packageCertIndexFound || !certIndexFound) {
        std::cout << "Package or cert not found; skipping signature check..." << std::endl;
    }

    return 0;
}
