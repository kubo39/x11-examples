# Hello World

## How to run

```console
$ Xephyr -screen 800x600 :1 &
[1] 16896
$ DISPLAY=:1 dub run
(...)
^C
$ kill 16896
XIO:  fatal IO error 11 (Resource temporarily unavailable) on X server ":1"
      after 11 requests (10 known processed) with 0 events remaining.
[1]  + done       Xephyr -screen 800x600 :1
```
