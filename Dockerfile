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
RUN npm install -g pm2

# Vue のビルド成果物をコピー
COPY --from=frontend-build /app/dist /app/frontend

# Go のバイナリをコピー
COPY --from=backend-build /app/app /app/backend/app

# バックエンド & フロントエンドの並列起動（pm2 を使用）
CMD ["pm2-runtime", "start", "--name", "backend", "--", "/app/backend/app"]



