#!/bin/bash
# Sử dụng thư mục /home trực tiếp
N8N_DIR="/home/n8n"
DOMAIN="sloyalty.sctv.vn"
# Tạo thư mục cho n8n
mkdir -p $N8N_DIR

# Kiểm tra và đặt quyền cho thư mục n8n_data
if [ ! -d "$N8N_DIR/n8n_data" ]; then
    mkdir -p "$N8N_DIR/n8n_data"
fi

# Đặt quyền cho thư mục n8n_data
chown -R 1000:1000 "$N8N_DIR/n8n_data"
chmod -R 755 "$N8N_DIR/n8n_data"

# Đặt quyền cho thư mục n8n
chown -R 1000:1000 $N8N_DIR
chmod -R 755 $N8N_DIR

# Tạo file docker-compose.yml
cat << EOF > $N8N_DIR/docker-compose.yml
version: "3"
services:
  n8n:
    image: n8nio/n8n
    restart: always
    ports:
      - "5678:5678"
    environment:
      - N8N_HOST=${DOMAIN}
      - N8N_PORT=5678
      - N8N_PROTOCOL=https
      - NODE_ENV=production
      - WEBHOOK_URL=https://${DOMAIN}
      - GENERIC_TIMEZONE=Asia/Ho_Chi_Minh
    volumes:
      - $N8N_DIR/n8n_data:/home/node/.n8n
EOF

# Khởi động các container
cd $N8N_DIR
if ! docker compose up -d; then
    echo "Khởi động Docker Compose thất bại."
    exit 1
fi

echo "N8n đã được cài đặt và cấu hình với SSL sử dụng Caddy. Truy cập https://${DOMAIN} để sử dụng."
echo "Các file cấu hình và dữ liệu được lưu trong $N8N_DIR"
