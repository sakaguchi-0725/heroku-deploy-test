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
FROM ubuntu:latest
WORKDIR /app

# 必要なツールをインストール（Heroku の環境向け）
RUN apt-get update && apt-get install -y ca-certificates nodejs npm

# Vue の静的ファイルを配信する `serve` をインストール
RUN npm install -g serve

# Vue のビルド成果物をコピー
COPY --from=frontend-build /app/dist /app/frontend

# Go のバイナリをコピー
COPY --from=backend-build /app/app /app/backend/app

# 起動スクリプトをコピー
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh  # 実行権限を付与

# `start.sh` を使ってバックエンド & フロントエンドを並列起動
CMD ["/app/start.sh"]





