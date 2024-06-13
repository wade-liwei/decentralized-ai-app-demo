# 基于Node官方镜像
FROM node:lts-alpine as build-stage
 
# 设置工作目录
WORKDIR /app
 
# 复制`package.json`和`package-lock.json`（如果有）
COPY package*.json ./
 
# 安装项目依赖
RUN npm install
 
# 复制项目文件和目录到工作目录
COPY . .
 
# 构建应用
RUN npm run build
 
# 生产环境使用Nginx
FROM nginx:stable-alpine as production-stage
 
# 从构建阶段复制构建结果到Nginx目录
COPY --from=build-stage /app/dist /usr/share/nginx/html
 
# 暴露80端口
EXPOSE 80
 
# 启动Nginx，并且Nginx将持续运行
CMD ["nginx", "-g", "daemon off;"]
