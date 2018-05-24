#
# Copyright (C) 2018 The LineageOS Project
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

# Very similar in role to the ramdisk board-defined
# symlinks created in system/core/rootdir/Android.mk.

ifdef BOARD_SYSTEM_EXTRA_FOLDERS
  CMD := mkdir -p $(BOARD_SYSTEM_EXTRA_FOLDERS)
endif

ifdef BOARD_SYSTEM_EXTRA_SYMLINKS
# BOARD_SYSTEM_EXTRA_SYMLINKS is a list of <target>:<link_name>.
  CMD += $(foreach s, $(BOARD_SYSTEM_EXTRA_SYMLINKS),          \
    $(eval system := $(PRODUCT_OUT)/$(TARGET_COPY_OUT_SYSTEM)) \
    $(eval p := $(subst :,$(space),$(s)))                      \
    $(eval target := $(word 1,$(p)))                           \
    $(eval link_name := $(system)/$(word 2,$(p)))              \
    ; mkdir -p $(dir $(link_name))                             \
    ; rm -rf $(link_name)                                      \
    ; ln -sf $(target) $(link_name))
endif

# Module name not important, just give the build system something
# to chew, and us something to hook our commands onto.
BOARD_SYSTEM_SYMLINKS := system.symlinks
.PHONY: $(BOARD_SYSTEM_SYMLINKS)

ALL_DEFAULT_INSTALLED_MODULES += $(BOARD_SYSTEM_SYMLINKS) := $(CMD)

