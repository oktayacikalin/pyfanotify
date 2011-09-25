cdef extern from "sys/fanotify.h":
    int fanotify_init(unsigned int __flags, unsigned int __event_f_flags)
    int fanotify_mark(int __fanotify_fd, unsigned int __flags,
                      unsigned long long __mask, int __dfd, char *__pathname)


def init(unsigned int flags, unsigned int event_f_flags):
    return fanotify_init(flags, event_f_flags)

def mark(int __fanotify_fd, unsigned int __flags, unsigned long long __mask,
         int __dfd, char *__pathname):
    return fanotify_mark(__fanotify_fd, __flags, __mask, __dfd, __pathname)
