ADDONSU_PREBUILTS_PATH := vendor/cm/addonsu/

ADDONSU_INSTALL_OUT := $(PRODUCT_OUT)/addonsu-install/
ADDONSU_INSTALL_TARGET := $(PRODUCT_OUT)/addonsu-$(TARGET_ARCH).zip

SU_BINARY := $(ALL_MODULES.su.BUILT)
UPDATER_BINARY := $(ALL_MODULES.updater.BUILT)

$(ADDONSU_INSTALL_TARGET): $(UPDATER_BINARY) $(SU_BINARY)
	$(hide) rm -rf $@ $(ADDONSU_INSTALL_OUT)
	$(hide) mkdir -p $(ADDONSU_INSTALL_OUT)/META-INF/com/google/android/
	$(hide) mkdir -p $(ADDONSU_INSTALL_OUT)/system/xbin
	$(hide) mkdir -p $(ADDONSU_INSTALL_OUT)/system/etc
	$(hide) mkdir -p $(ADDONSU_INSTALL_OUT)/system/addon.d
	$(hide) touch $(ADDONSU_INSTALL_OUT)/system/etc/addonsu
	$(hide) cp $(SU_BINARY) $(ADDONSU_INSTALL_OUT)/system/xbin/
	$(hide) cp $(UPDATER_BINARY) $(ADDONSU_INSTALL_OUT)/META-INF/com/google/android/update-binary
	$(hide) cp $(ADDONSU_PREBUILTS_PATH)/51-addonsu.sh $(ADDONSU_INSTALL_OUT)/system/addon.d/
	$(hide) cp $(ADDONSU_PREBUILTS_PATH)/mount-system.sh $(ADDONSU_INSTALL_OUT)/
	$(hide) cp $(ADDONSU_PREBUILTS_PATH)/updater-script-install $(ADDONSU_INSTALL_OUT)/META-INF/com/google/android/updater-script
	$(hide) (cd $(ADDONSU_INSTALL_OUT) && zip -qr $@ *)

.PHONY: addonsu
addonsu: $(ADDONSU_INSTALL_TARGET)
	@echo "Done: $(ADDONSU_INSTALL_TARGET)"


ADDONSU_REMOVE_OUT := $(PRODUCT_OUT)/addonsu-remove/
ADDONSU_REMOVE_TARGET := $(PRODUCT_OUT)/addonsu-remove-$(TARGET_ARCH).zip

$(ADDONSU_REMOVE_TARGET): $(UPDATER_BINARY)
	$(hide) rm -rf $@ $(ADDONSU_REMOVE_OUT)
	$(hide) mkdir -p $(ADDONSU_REMOVE_OUT)/META-INF/com/google/android/
	$(hide) cp $(UPDATER_BINARY) $(ADDONSU_REMOVE_OUT)/META-INF/com/google/android/update-binary
	$(hide) cp $(ADDONSU_PREBUILTS_PATH)/mount-system.sh $(ADDONSU_REMOVE_OUT)/
	$(hide) cp $(ADDONSU_PREBUILTS_PATH)/updater-script-remove $(ADDONSU_REMOVE_OUT)/META-INF/com/google/android/updater-script
	$(hide) (cd $(ADDONSU_REMOVE_OUT) && zip -qr $@ *)

.PHONY: addonsu-remove
addonsu-remove: $(ADDONSU_REMOVE_TARGET)
	@echo "Done: $(ADDONSU_REMOVE_TARGET)"
