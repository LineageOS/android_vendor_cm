#
# CM-specific macros
#
define uniq
$(if $1,$(firstword $1) $(call uniq,$(filter-out $(firstword $1),$1)))
endef

# The short names of all of the remote prebuilt targets
# in the system. For each element of ALL_REMOTE_MODULES,
# three other variables are defined:
#   $(ALL_REMOTE_MODULES.$(LOCAL_MODULE).URL)
#   $(ALL_REMOTE_MODULES.$(LOCAL_MODULE).MD5_URL)
#   $(ALL_REMOTE_MODULES.$(LOCAL_MODULE).PREBUILT)
# The URL variable contains the URL of the prebuilt binary,
# MD5_URL contains the url of the md5sum of the binary and
# PREBUILT the target path of the binary.
ALL_REMOTE_MODULES :=
