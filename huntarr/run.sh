#!/bin/bash
set -e

echo "Starting Huntarr..."
cd /app
exec python3 main.py
