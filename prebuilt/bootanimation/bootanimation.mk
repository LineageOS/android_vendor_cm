# Copyright (C) 2017 AIMROM Projet
#
#         ANAND RAMACHANDRAN
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

ifneq ($(filter 480,$(TARGET_SCREEN_WIDTH)),)
    PRODUCT_COPY_FILES += \
        vendor/aim/prebuilt/bootanimation/480.zip:system/media/bootanimation.zip
endif
ifneq ($(filter 720,$(TARGET_SCREEN_WIDTH)),)
    PRODUCT_COPY_FILES += \
        vendor/aim/prebuilt/bootanimation/720.zip:system/media/bootanimation.zip
endif
ifneq ($(filter 1080,$(TARGET_SCREEN_WIDTH)),)
    PRODUCT_COPY_FILES += \
        vendor/aim/prebuilt/bootanimation/1080.zip:system/media/bootanimation.zip
endif
ifneq ($(filter 1440,$(TARGET_SCREEN_WIDTH)),)
    PRODUCT_COPY_FILES += \
        vendor/aim/prebuilt/bootanimation/1440.zip:system/media/bootanimation.zip
endif
