#!/usr/bin/env sh

# Ensure this script is executable!

cmd="/bin/app"
if [ "$REMOTE_DEBUG_PORT" ]; then
  echo "Starting application with remote debugging on port $REMOTE_DEBUG_PORT"
  dlvFlags="--listen=:$REMOTE_DEBUG_PORT --headless=true --log --api-version=2 --accept-multiclient"
  execFlags=""
  # Simply setting this environment variable is enough to force the debugger to
  # pause on start --- we don't care about the value.
  if [ "$REMOTE_DEBUG_PAUSE_ON_START" ]; then
    echo "Process execution will be paused until a debug session is attached"
  else
    execFlags="$execFlags --continue"
  fi
  cmd="/bin/dlv $dlvFlags exec $cmd $execFlags -- "
fi

echo "Executing command: $cmd $*"

exec $cmd "$@"
