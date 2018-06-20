LOCAL_PATH := $(call my-dir)

$(LOCAL_PATH)/Term.apk:
	curl -L -o $(LOCAL_PATH)/Term.apk -O -L https://jackpal.github.com/Android-Terminal-Emulator/downloads/Term.apk

$(LOCAL_PATH)/lib/armeabi/%.so: $(LOCAL_PATH)/Term.apk
	unzip -o -d $(LOCAL_PATH) $(LOCAL_PATH)/Term.apk lib/armeabi/$(@F)

include $(CLEAR_VARS)

LOCAL_MODULE := Terminal
LOCAL_SRC_FILES := Term.apk
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_REQUIRED_MODULES := libjackpal-termexec2 libjackpal-androidterm5

include $(BUILD_PREBUILT)


include $(CLEAR_VARS)

LOCAL_MODULE := libjackpal-termexec2
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)
LOCAL_SRC_FILES := lib/armeabi/libjackpal-termexec2.so
LOCAL_MODULE_TAGS := optional

include $(BUILD_PREBUILT)


include $(CLEAR_VARS)

LOCAL_MODULE := libjackpal-androidterm5
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)
LOCAL_SRC_FILES := lib/armeabi/libjackpal-androidterm5.so
LOCAL_MODULE_TAGS := optional

include $(BUILD_PREBUILT)