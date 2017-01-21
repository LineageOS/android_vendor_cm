#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mount.h>

#include <fs_mgr.h>

static void remove_trailing_slashes(char *n)
{
    int len;

    len = strlen(n) - 1;
    while ((*(n + len) == '/') && len) {
        *(n + len) = '\0';
        len--;
    }
}

static int fs_match(const char *in1, const char *in2)
{
    char *n1;
    char *n2;
    int ret;

    n1 = strdup(in1);
    n2 = strdup(in2);

    remove_trailing_slashes(n1);
    remove_trailing_slashes(n2);

    ret = !strcmp(n1, n2);

    free(n1);
    free(n2);

    return ret;
}

int main()
{
    static struct fstab *fstab = NULL;

    fstab = fs_mgr_read_fstab("/etc/recovery.fstab");
    if (!fstab) {
        fprintf(stderr, "failed to read /etc/recovery.fstab\n");
        return -1;
    }

    if (umount("/system")) {
        if (errno != EINVAL) {
            // /system is mounted and we couldn't unmount it
            fprintf(stderr, "failed to umount /system\n");
            return -1;
        }
    }

    for (int i = 0; i < fstab->num_entries; i++) {
        if (!fs_match(fstab->recs[i].mount_point, "/system")) {
            continue;
        }
        const struct fstab_rec *rec = &fstab->recs[i];
        unsigned long mountflags = rec->flags & ~MS_RDONLY;
        if (!mount(rec->blk_device, rec->mount_point, rec->fs_type, mountflags, rec->fs_options)) {
            return 0;
        }
    }

    fprintf(stderr, "failed to mount /system\n");

    return -1;
}
