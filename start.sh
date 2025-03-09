#!/bin/bash

# Heroku の環境変数 `$PORT` を使用（デフォルト 8080）
BACKEND_PORT=${PORT:-8080}
FRONTEND_PORT=3000

echo "Starting Backend on port $BACKEND_PORT..."
/app/backend/app &

echo "Starting Frontend on port $FRONTEND_PORT..."
npx serve -s /app/frontend -l $FRONTEND_PORT &

# どちらかのプロセスが終了したらスクリプトを終了
wait

