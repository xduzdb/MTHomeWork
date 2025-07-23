#!/bin/bash

echo "等待应用程序启动..."
sleep 3

echo "启动日志监控..."
xcrun simctl spawn booted log stream --predicate 'process == "HomeWork"' --style compact &
LOG_PID=$!

echo "等待5秒让日志开始收集..."
sleep 5

echo "停止日志监控..."
kill $LOG_PID 2>/dev/null

echo "获取最近的日志..."
xcrun simctl spawn booted log show --predicate 'process == "HomeWork"' --last 30s --style compact 