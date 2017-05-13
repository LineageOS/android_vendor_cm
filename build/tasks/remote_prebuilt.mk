# Copyright (C) 2017 The LineageOS Project
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

ifeq ($(OFFLINE_BUILD),true)
$(warning Doing an offline build, some prebuilt modules could be outdated or missing)
$(warning Update the remote prebuilt modules running "OFFLINE_BUILD=false mka fetchprebuilts")
endif

.PHONY: fetchprebuilts
fetchprebuilts:
	$(foreach m,$(ALL_REMOTE_MODULES),$(call get-prebuilt-module,$(m)))

# $(1): url
# $(2): destination path
define download-prebuilt-module
  ./vendor/cm/build/tasks/http_curl_prebuilt.sh $(1) $(2);
endef

# $(1): module name
define get-prebuilt-module
  $(eval url := $(ALL_REMOTE_MODULES.$(1).URL))
  $(eval path := $(ALL_REMOTE_MODULES.$(1).PREBUILT))
  $(eval md5url := $(ALL_REMOTE_MODULES.$(1).MD5_URL))
  $(call download-prebuilt-module,$(md5url),$(path).md5)
  $(hide) if [ ! -f $(path) ]; then \
            echo "Downloading: $(url)"; \
            $(call download-prebuilt-module,$(url),$(path)) \
          else \
            temp_checksum=$(shell md5sum $(path) | cut -d ' ' -f1); \
            if [ "$$temp_checksum" != "$(shell cat $(path).md5 | cut -d ' ' -f1)" ]; then \
              echo "Downloading: $(url)"; \
              rm -rf $(path); \
              $(call download-prebuilt-module,$(url),$(path)) \
            fi; \
          fi; \
          rm -f $(path).md5
endef
