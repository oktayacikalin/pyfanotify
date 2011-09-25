import fanotify
fan = fanotify.FileAccessNotifier()
fan.watch_filesystem('/')
while True:
    fan.read_event()
    print '--'

