import fanotify
fan = fanotify.FileAccessNotifier()
fan.watch_mount('/')
#XXX figure out best way to use fanotify to watch a large chunk of a filesystem but not necessarily all of it
while True:
    fn = fan.read_event()
    if not fn.startswith('/tmp'):
        print fn
