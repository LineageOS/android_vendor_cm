#
# Copyright (C) 2016 The CyanogenMod Project
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
#
LOCAL_PATH := $(call my-dir)

my_archs := arm arm64 x86 x86_64
my_src_arch := $(call get-prebuilt-src-arch, $(my_archs))

LOCAL_REQUIRED_MODULES := su
TARGET_GENERATED_ADDON_SU := $(TARGET_OUT_INTERMEDIATES)/ADDON/addon_su-$(my_src_arch).zip

define build-addon-su
    sh vendor/cm/bootanimation/generate-addon-su.sh \
    $(PRODUCT_OUT) \
    $(TARGET_OUT_INTERMEDIATES)/ADDON \
    $(PRODUCT_OUT)/system/xbin/su \
    $(PRODUCT_OUT)/obj/EXECUTABLES/updater_intermediates/updater \
    $(LOCAL_PATH)/51-addon-su.sh
endef

$(TARGET_GENERATED_ADDON_SU):
	@echo "Building su addon"
	$(build-addon-su)

include $(CLEAR_VARS)
LOCAL_MODULE := addon_su.zip
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT)/..
LOCAL_MODULE_TARGET_ARCH := $(my_src_arch)

include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE): $(TARGET_ADDON_SU)
	@mkdir -p $(dir $@)
	@cp $(TARGET_ADDON_SU) $@
