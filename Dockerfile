# 1. build
FROM node:20-alpine AS builder
WORKDIR /app

ARG REACT_APP_API_URL=""
ENV REACT_APP_API_URL=$REACT_APP_API_URL

# 캐시 활용을 위해 package 파일들 먼저 복사
COPY package.json package-lock.json ./
RUN npm install

# 전체 소스 복사 및 빌드
COPY . .
RUN npm run build

# 2. prod
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

#  -g 옵션 및 세미콜론 확인
CMD ["nginx", "-g", "daemon off;"]