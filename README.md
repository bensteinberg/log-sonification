log-sonification
================
These scripts are an experiment in the sonification of the [DASH](http://dash.harvard.edu/) Tomcat log.  They're intended to be used alongside a visualization using [logstalgia](https://code.google.com/p/logstalgia/).  They don't require the use of logstalgia, or DASH; they could be adapted to listen to other logs.

emitter.pl takes as input a running tail of the log and emits it line by line according to timestamp, thereby getting around tail's buffering.

log2params.pl turns each log entry into MIDI note, panning value, and strike value.

player.ck plays the entries using [ChucK](http://chuck.stanford.edu/).

A typical invocation without logstalgia looks like this:
```
ssh user@host tail -f /path/to/logfile | unbuffer -p ./emitter.pl | unbuffer -p ./log2params.pl | chuck ./player.ck
```
An invocation with logstalgia looks like this:
```
cd ~/bin/logstalgia-1.0.3
ssh user@host tail -f /path/to/logfile | \
unbuffer -p ~/Documents/code/log-sonification/emitter.pl | \
unbuffer -p tee \
>(./logstalgia --sync) \
>(unbuffer -p ~/Documents/code/log-sonification/log2params.pl | chuck ~/Documents/code/log-sonification/player.ck)
```

I've found it necessary to use unbuffer, part of expect, to keep the data flowing line by line.