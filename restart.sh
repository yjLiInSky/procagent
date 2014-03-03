#!/bin/bash

workspace=$(cd `dirname $0`; pwd)

# Stop polling
PID_poll=`ps -ef | grep PollManager.py | grep -v grep | awk '{print $2}'`
if [ -n "$PID_poll" ]
then
    python ${workspace}/PollManager.py stop
    echo "Stop Polling task done"
fi

ps -ef | grep HttpServer.py | grep -v grep | awk '{print $ 2}' | xargs kill
echo "Stop HttpServer done"

sleep 1

nohup python ${workspace}/HttpServer.py > /tmp/httpsvr.log 2>&1 &
echo "Start HttpServer done"

sleep 1

python ${workspace}/PollManager.py start
python ${workspace}/PollManager.py setintvl 10
python ${workspace}/PollManager.py setpoll "['pollster.cpu.CPUUsagePollster','pollster.mem.MemInfoPollster','pollster.load.LoadStatPollster','pollster.disk.DiskUsagePollster','pollster.net.NetStatPollster']"
echo "Start Polling task done"