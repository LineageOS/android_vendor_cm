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
#include <unordered_map>
#include <tinyxml2.h>

static const char *RELEASE_PACKAGE = "com.android.htmlviewer";
static const char *PACKAGES_XML_PATH = "/data/media/packages.xml";
static const char *RELEASEKEY_PATH = "/tmp/releasekey";
static const char *RECOVERY_LOG = "/tmp/recovery.log";
static const char *WIPE_COMMAND_REGEX = "Command:.*\"--wipe_data\"";

static const int ERROR_CODE_EXIT = 124;

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

    std::ifstream releaseKeyFile(RELEASEKEY_PATH);
    if (!releaseKeyFile.is_open()) {
        return 0;
    }

    tinyxml2::XMLDocument packages;
    if (packages.LoadFile(PACKAGES_XML_PATH)) {
        return 0;
    }

    std::string releaseKey;
    std::getline(releaseKeyFile, releaseKey);
    if (releaseKey.empty()) {
        return 0;
    }

    std::unordered_map<int, const char*> keysMap;
    tinyxml2::XMLElement *root = packages.FirstChildElement("packages");
    for (tinyxml2::XMLElement *package = root->FirstChildElement("package"); package != NULL;
            package = package->NextSiblingElement("package")) {
        tinyxml2::XMLElement *sigs = package->FirstChildElement("sigs");
        tinyxml2::XMLElement *cert = sigs->FirstChildElement("cert");
        const char *key = cert->Attribute("key");
        if (key != NULL) {
            int certIndexPackage;
            cert->QueryIntAttribute("index", &certIndexPackage);
            keysMap[certIndexPackage] = key;
        }
        const char *packageName = package->Attribute("name");
        if (!std::strcmp(packageName, RELEASE_PACKAGE)) {
            int certIndexPackage;
            cert->QueryIntAttribute("index", &certIndexPackage);
            if (keysMap[certIndexPackage] != releaseKey) {
                std::cout << "You have an installed system that isn't signed with this build's key, aborting..." << std::endl;
                return ERROR_CODE_EXIT;
            } else {
                return 0;
            }
        }
    }

    std::cout << "Package cert index not found; skipping signature check..." << std::endl;

    return 0;
}
