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

# Very similar in scope to the ramdisk board-defined
# symlinks created in system/core/rootdir/Android.mk.

LOCAL_POST_INSTALL_CMD := mkdir -p $(BOARD_SYSTEM_EXTRA_FOLDERS)

ifdef BOARD_SYSTEM_EXTRA_SYMLINKS
# BOARD_SYSTEM_EXTRA_SYMLINKS is a list of <target>:<link_name>.
  LOCAL_POST_INSTALL_CMD += $(foreach s, $(BOARD_SYSTEM_EXTRA_SYMLINKS),\
    $(eval p := $(subst :,$(space),$(s)))\
    ; mkdir -p $(dir $(TARGET_COPY_OUT_SYSTEM)/$(word 2,$(p))) \
    ; ln -sf $(word 1,$(p)) $(TARGET_COPY_OUT_SYSTEM)/$(word 2,$(p)))
endif

$(LOCAL_INSTALLED_MODULE): PRIVATE_POST_INSTALL_CMD := $(LOCAL_POST_INSTALL_CMD)

