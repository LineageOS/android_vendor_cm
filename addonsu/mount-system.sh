#!/sbin/sh

if mount /system; then
    exit 0
fi

# Try to get the block from /etc/recovery.fstab
block=`cat /etc/recovery.fstab | grep -v "^ *#" | grep -m1 /system | grep -o '/dev/[^ ]*'`
if [ -n "$block" ] && mount $block /system; then
    exit 0
fi

exit 1
