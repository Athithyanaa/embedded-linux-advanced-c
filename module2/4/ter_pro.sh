PID=$(ps -eo pid,%mem --sort=-%mem | awk 'NR==2 {print $1}')

echo "Process with highest memory usage PID = $PID"

kill -9 $PID

echo "Process $PID terminated."
