INSTALLED_ADDONSU_OUT := $(PRODUCT_OUT)/addonsu/
INSTALLED_ADDONSU_TARGET := $(PRODUCT_OUT)/addonsu.zip

ADDONSU_PREBUILTS_PATH := vendor/cm/addonsu/

$(INSTALLED_ADDONSU_TARGET): $(TARGET_OUT)/bin/updater $(TARGET_OUT)/xbin/su \
		$(TARGET_OUT)/bin/mount-system
	$(hide) rm -rf $@ $(INSTALLED_ADDONSU_OUT)
	$(hide) mkdir -p $(INSTALLED_ADDONSU_OUT)/META-INF/com/google/android/
	$(hide) mkdir -p $(INSTALLED_ADDONSU_OUT)/system/xbin
	$(hide) mkdir -p $(INSTALLED_ADDONSU_OUT)/system/addon.d
	$(hide) mv $(TARGET_OUT)/bin/mount-system $(INSTALLED_ADDONSU_OUT)/
	$(hide) mv $(TARGET_OUT)/xbin/su $(INSTALLED_ADDONSU_OUT)/system/xbin/
	$(hide) cp $(ADDONSU_PREBUILTS_PATH)/51-addonsu.sh $(INSTALLED_ADDONSU_OUT)/system/addon.d/
	$(hide) cp $(ADDONSU_PREBUILTS_PATH)/updater-script $(INSTALLED_ADDONSU_OUT)/META-INF/com/google/android/updater-script
	$(hide) cp $(TARGET_OUT)/bin/updater $(INSTALLED_ADDONSU_OUT)/META-INF/com/google/android/update-binary
	$(hide) (cd $(INSTALLED_ADDONSU_OUT) && zip -qr $@ *)

.PHONY: addonsu
addonsu: $(INSTALLED_ADDONSU_TARGET)
	@echo "Done: $(INSTALLED_ADDONSU_TARGET)"
