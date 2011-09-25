import os
import fanotify

fan_fd = fanotify.init(0, os.O_RDONLY | os.O_LARGEFILE)
print fan_fd

