LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := mount-system
LOCAL_C_INCLUDES := system/core/fs_mgr/include
LOCAL_SRC_FILES := mount-system.cpp
LOCAL_STATIC_LIBRARIES := libfs_mgr
LOCAL_WHOLE_STATIC_LIBRARIES := libcutils
LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)
