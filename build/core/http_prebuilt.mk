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

PREBUILT_MODULE_ARCHIVE := vendor/cm/prebuilt/archive/$(LOCAL_MODULE)

ALL_REMOTE_MODULES += $(LOCAL_MODULE)
ALL_REMOTE_MODULES.$(LOCAL_MODULE).URL := $(LOCAL_HTTP_PATH)/$(LOCAL_HTTP_FILENAME)
ALL_REMOTE_MODULES.$(LOCAL_MODULE).MD5_URL := $(LOCAL_HTTP_PATH)/$(LOCAL_HTTP_MD5SUM)
ALL_REMOTE_MODULES.$(LOCAL_MODULE).PREBUILT := $(PREBUILT_MODULE_ARCHIVE)/$(LOCAL_HTTP_FILENAME)

LOCAL_PREBUILT_MODULE_FILE := $(ALL_REMOTE_MODULES.$(LOCAL_MODULE).PREBUILT)

ifneq ($(OFFLINE_BUILD),true)
$(LOCAL_PREBUILT_MODULE_FILE): module := $(LOCAL_MODULE)
$(LOCAL_PREBUILT_MODULE_FILE):
	$(call get-prebuilt,$(module))
endif

include $(BUILD_PREBUILT)
