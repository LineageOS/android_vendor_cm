# Copyright (C) 2017 Unlegacy-Android
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

ifneq ($(TARGET_PRODUCT),sdk)
ifeq ($(filter generic%,$(TARGET_DEVICE)),)
ifneq ($(TARGET_NO_KERNEL),true)
ifneq ($(recovery_fstab),)

BOOT_ZIP_FROM_IMAGE_SCRIPT := ./vendor/unlegacy/build/tools/releasetools/boot_flash_from_image
KERNEL_PATH := $(TARGET_KERNEL_SOURCE)/arch/arm/configs/$(TARGET_KERNEL_CONFIG)

.PHONY: bootzip

bootzip: bootimage
	$(BOOT_ZIP_FROM_IMAGE_SCRIPT) \
	   $(recovery_fstab) \
	   $(OUT) \
	   $(TARGET_DEVICE)

endif    # recovery_fstab is defined
endif    # TARGET_NO_KERNEL != true
endif    # TARGET_DEVICE != generic*
endif    # TARGET_PRODUCT != sdk
