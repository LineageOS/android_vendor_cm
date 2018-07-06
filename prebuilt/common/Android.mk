LOCAL_PATH := $(call my-dir)

# a wrapper for curl which provides wget syntax, for compatibility
include $(CLEAR_VARS)
LOCAL_MODULE := wget
LOCAL_SRC_FILES := bin/wget
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
include $(BUILD_PREBUILT)


# Prebuilt apk's included in Spark builds


include $(CLEAR_VARS)
LOCAL_MODULE := Amaze
LOCAL_MODULE_OWNER := koboldo
LOCAL_SRC_FILES := $(wildcard app/$(LOCAL_MODULE)*.apk)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .apk
LOCAL_MODULE_CLASS := APPS
LOCAL_CERTIFICATE := PRESIGNED
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := VinylMusicPlayer
LOCAL_MODULE_OWNER := koboldo
LOCAL_SRC_FILES := $(wildcard app/$(LOCAL_MODULE)*.apk)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .apk
LOCAL_MODULE_CLASS := APPS
LOCAL_CERTIFICATE := PRESIGNED
include $(BUILD_PREBUILT)
