import fanotify
fan = fanotify.FileAccessNotifier()
fan.watch_mount('/')
#fan.watch_dir('/home/menno')
#XXX figure out best way to use fanotify to watch a large chunk of a filesystem but not necessarily all of it
#XXX detecting deletions reliabily?? check event masks
while True:
    fn = fan.read_event()
    if not fn.startswith('/tmp'):
        print fn
