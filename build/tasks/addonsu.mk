ADDONSU_PREBUILTS_PATH := vendor/cm/addonsu/

INSTALLED_ADDONSU_INSTALL_OUT := $(PRODUCT_OUT)/addonsu-install/
INSTALLED_ADDONSU_INSTALL_TARGET := $(PRODUCT_OUT)/addonsu-$(TARGET_ARCH).zip

$(INSTALLED_ADDONSU_INSTALL_TARGET): $(TARGET_OUT_EXECUTABLES)/updater \
		$(TARGET_OUT_OPTIONAL_EXECUTABLES)/su
	$(hide) rm -rf $@ $(INSTALLED_ADDONSU_INSTALL_OUT)
	$(hide) mkdir -p $(INSTALLED_ADDONSU_INSTALL_OUT)/META-INF/com/google/android/
	$(hide) mkdir -p $(INSTALLED_ADDONSU_INSTALL_OUT)/system/xbin
	$(hide) mkdir -p $(INSTALLED_ADDONSU_INSTALL_OUT)/system/addon.d
	$(hide) mv $(TARGET_OUT_OPTIONAL_EXECUTABLES)/su $(INSTALLED_ADDONSU_INSTALL_OUT)/system/xbin/
	$(hide) cp $(TARGET_OUT_EXECUTABLES)/updater $(INSTALLED_ADDONSU_INSTALL_OUT)/META-INF/com/google/android/update-binary
	$(hide) cp $(ADDONSU_PREBUILTS_PATH)/51-addonsu.sh $(INSTALLED_ADDONSU_INSTALL_OUT)/system/addon.d/
	$(hide) cp $(ADDONSU_PREBUILTS_PATH)/mount-system.sh $(INSTALLED_ADDONSU_INSTALL_OUT)/
	$(hide) cp $(ADDONSU_PREBUILTS_PATH)/updater-script-install $(INSTALLED_ADDONSU_INSTALL_OUT)/META-INF/com/google/android/updater-script
	$(hide) (cd $(INSTALLED_ADDONSU_INSTALL_OUT) && zip -qr $@ *)

.PHONY: addonsu
addonsu: $(INSTALLED_ADDONSU_INSTALL_TARGET)
	@echo "Done: $(INSTALLED_ADDONSU_INSTALL_TARGET)"


INSTALLED_ADDONSU_REMOVE_OUT := $(PRODUCT_OUT)/addonsu-remove/
INSTALLED_ADDONSU_REMOVE_TARGET := $(PRODUCT_OUT)/addonsu-remove-$(TARGET_ARCH).zip

$(INSTALLED_ADDONSU_REMOVE_TARGET): $(TARGET_OUT_EXECUTABLES)/updater
	$(hide) rm -rf $@ $(INSTALLED_ADDONSU_REMOVE_OUT)
	$(hide) mkdir -p $(INSTALLED_ADDONSU_REMOVE_OUT)/META-INF/com/google/android/
	$(hide) cp $(TARGET_OUT_EXECUTABLES)/updater $(INSTALLED_ADDONSU_REMOVE_OUT)/META-INF/com/google/android/update-binary
	$(hide) cp $(ADDONSU_PREBUILTS_PATH)/mount-system.sh $(INSTALLED_ADDONSU_REMOVE_OUT)/
	$(hide) cp $(ADDONSU_PREBUILTS_PATH)/updater-script-remove $(INSTALLED_ADDONSU_REMOVE_OUT)/META-INF/com/google/android/updater-script
	$(hide) (cd $(INSTALLED_ADDONSU_REMOVE_OUT) && zip -qr $@ *)

.PHONY: addonsu-remove
addonsu-remove: $(INSTALLED_ADDONSU_REMOVE_TARGET)
	@echo "Done: $(INSTALLED_ADDONSU_REMOVE_TARGET)"
