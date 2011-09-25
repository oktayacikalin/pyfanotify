import os

cdef extern from "fcntl.h":
    enum: O_RDONLY
    enum: O_LARGEFILE
    enum: AT_FDCWD

cdef extern from "unistd.h":
    ssize_t read(int fd, void *buf, size_t count)
    int close(int fd)

cdef extern from "sys/fanotify.h":
    int fanotify_init(unsigned int __flags, unsigned int __event_f_flags)
    int fanotify_mark(int __fanotify_fd, unsigned int __flags,
                      unsigned long long __mask, int __dfd, char *__pathname)

cdef extern from "linux/fanotify.h":
    enum: FAN_ACCESS
    enum: FAN_MODIFY
    enum: FAN_CLOSE_WRITE
    enum: FAN_CLOSE_NOWRITE
    enum: FAN_OPEN
    enum: FAN_CLOSE

    enum: FAN_ALL_EVENTS

    enum: FAN_OPEN_PERM
    enum: FAN_ACCESS_PERM

    enum: FAN_ONDIR

    enum: FAN_EVENT_ON_CHILD

    enum: FAN_CLASS_NOTIF
    enum: FAN_CLASS_CONTENT
    enum: FAN_CLASS_PRE_CONTENT

    # For use with fanotify_mark
    enum: FAN_MARK_ADD
    enum: FAN_MARK_REMOVE
    enum: FAN_MARK_DONT_FOLLOW
    enum: FAN_MARK_ONLYDIR
    enum: FAN_MARK_MOUNT
    enum: FAN_MARK_IGNORED_MASK
    enum: FAN_MARK_IGNORED_SURV_MODIFY
    enum: FAN_MARK_FLUSH

    enum: FAN_ALL_MARK_FLAGS

    cdef struct fanotify_event_metadata:
        int fd

#XXX raise OSError when things go bad

cdef class FileAccessNotifier:
    cdef int fan_fd

    def __cinit__(self):
        self.fan_fd = fanotify_init(FAN_CLASS_NOTIF, O_RDONLY | O_LARGEFILE)
        print self.fan_fd
        #XXX check

    def watch_filesystem(self, char *path):
        #XXX this should take the mask
        event_mask = FAN_ACCESS | FAN_MODIFY | FAN_CLOSE_WRITE | FAN_CLOSE_NOWRITE | FAN_OPEN
        result = fanotify_mark(self.fan_fd, FAN_MARK_ADD | FAN_MARK_MOUNT, event_mask, AT_FDCWD, path)
        #XXX check
        print result

    def read_event(self):
        cdef fanotify_event_metadata metadata
        num_bytes = read(self.fan_fd, &metadata, sizeof(fanotify_event_metadata));
        print num_bytes, sizeof(fanotify_event_metadata)

        if metadata.fd >= 0:
            #XXX change to native C
            path = "/proc/self/fd/%d" % metadata.fd
            print os.readlink(path)
        else:
            print "?:"

        if metadata.fd >= 0 and close(metadata.fd) != 0:
            print 'error'   #XXX
        

    def __iter__(self):
        for x in (1, 2, 3):
            yield x
    


# struct fanotify_event_metadata {
#         __u32 event_len;
#         __u8 vers;
#         __u8 reserved;
#         __u16 metadata_len;
#         __aligned_u64 mask;
#         __s32 fd;
#         __s32 pid;
# };

