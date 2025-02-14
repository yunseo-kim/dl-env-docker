#!/bin/bash
# Run SSH daemon in the background
/usr/sbin/sshd

# Move to the workspace directory and run Jupyter Lab
cd "$HOME/workspace"
exec jupyter lab --no-browser --autoreload --ip=0.0.0.0 --notebook-dir="$HOME/workspace"
