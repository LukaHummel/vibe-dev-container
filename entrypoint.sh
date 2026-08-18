#!/bin/bash

# Start t3 serve in the background as user codespace
nohup t3 serve --host 0.0.0.0 > /home/codespace/.t3-serve.log 2>&1 &

# Execute the default container process (e.g., bash or sleep infinity)
exec "$@"