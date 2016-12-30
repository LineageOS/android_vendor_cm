# Copyright (C) 2015 The CyanogenMod Project
#           (C) 2017 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ifeq ($(strip $(LOCAL_HTTP_PATH)),)
  $(error LOCAL_HTTP_PATH not defined.)
endif

ifeq ($(strip $(LOCAL_HTTP_FILENAME)),)
  $(error LOCAL_HTTP_FILENAME not defined.)
endif

ifeq ($(strip $(LOCAL_HTTP_MD5SUM)),)
  $(error LOCAL_HTTP_MD5SUM not defined.)
endif

LOCAL_PREBUILT_MODULE_ARCHIVE := vendor/cm/prebuilt/archive/$(LOCAL_MODULE)
LOCAL_PREBUILT_MODULE_FILE    := $(LOCAL_PREBUILT_MODULE_ARCHIVE)/$(LOCAL_HTTP_FILENAME).tmp
LOCAL_PREBUILT_MODULE_MD5SUM  := $(LOCAL_PREBUILT_MODULE_ARCHIVE)/$(LOCAL_HTTP_MD5SUM)

OBJ_PREBUILT_MODULE_FILE := $(call intermediates-dir-for,$(LOCAL_MODULE_CLASS),$(LOCAL_MODULE),,COMMON)/$(LOCAL_HTTP_FILENAME)

$(LOCAL_PREBUILT_MODULE_FILE): tmpfile  := $(LOCAL_PREBUILT_MODULE_FILE)
$(LOCAL_PREBUILT_MODULE_FILE): filename := $(strip $(subst .tmp, , $(tmpfile)))
$(LOCAL_PREBUILT_MODULE_FILE): checksum := $(LOCAL_PREBUILT_MODULE_MD5SUM)
$(LOCAL_PREBUILT_MODULE_FILE): tmpsum   := $(LOCAL_PREBUILT_MODULE_ARCHIVE)/tmp.md5sum

define curl-checksum
  @echo "Pulling comparison md5sum for $(LOCAL_HTTP_FILENAME)"
  $(hide) ./vendor/cm/build/tasks/http_curl_prebuilt.sh $(LOCAL_HTTP_PATH)/$(LOCAL_HTTP_MD5SUM) $(tmpsum)
endef

define audit-checksum
  @echo "Downloading: $(LOCAL_HTTP_FILENAME) (version $(LOCAL_HTTP_FILE_VERSION))" -> $(tmpfile);
  $(hide) if [ ! -f $(filename) ]; then \
            ./vendor/cm/build/tasks/http_curl_prebuilt.sh $(LOCAL_HTTP_PATH)/$(LOCAL_HTTP_FILENAME) $(tmpfile); \
            mv $(tmpfile) $(filename); \
          else \
            if [ $(shell echo $(md5sum $(filename))) != $(shell cat $(tmpsum) | cut -d ' ' -f1) ]; then \
              rm -rf $(filename); \
              ./vendor/cm/build/tasks/http_curl_prebuilt.sh $(LOCAL_HTTP_PATH)/$(LOCAL_HTTP_FILENAME) $(tmpfile); \
              mv $(tmpfile) $(filename); \
            fi; \
          fi; \
          rm $(tmpsum);
endef

define cleanup
  @echo "Copying: $(LOCAL_HTTP_FILENAME) -> $(dir $(OBJ_PREBUILT_MODULE_FILE))"
  $(hide) mkdir -p $(OBJ_PREBUILT_MODULE_FILE)
  $(hide) cp $(filename) $(OBJ_PREBUILT_MODULE_FILE)
endef

$(LOCAL_PREBUILT_MODULE_FILE):
	$(call curl-checksum)
	$(call audit-checksum)
	$(call cleanup)

include $(BUILD_PREBUILT)

# the "fetchprebuilts" target will go through and pre-download all of the maven dependencies in the tree
fetchprebuilts: $(LOCAL_PREBUILT_MODULE_FILE)
