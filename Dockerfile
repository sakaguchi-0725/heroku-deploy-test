# Frontend build
FROM node:18 AS frontend-build
WORKDIR /app
COPY frontend ./
RUN npm install && npm run build

# Backend build
FROM golang:1.23 AS backend-build
WORKDIR /app
COPY backend ./
RUN go mod tidy && go build -o app

# 実行環境
FROM alpine:latest
WORKDIR /app

# 必要なツールをインストール
RUN apk --no-cache add ca-certificates nodejs npm gcompat

# pm2 でプロセス管理
RUN npm install -g pm2 serve

# Vue のビルド成果物をコピー
COPY --from=frontend-build /app/dist /app/frontend

# Go のバイナリをコピー
COPY --from=backend-build /app/app /app/backend/app

# `processes.json` をコンテナにコピー
COPY processes.json /app/processes.json

# バックエンド & フロントエンドの並列起動
CMD ["sh", "-c", "PORT=${PORT:-8080} FRONTEND_PORT=3000 pm2-runtime start /app/processes.json"]




