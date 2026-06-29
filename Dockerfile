# ================================
# Stage 1: Builder
# ================================
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm install --omit=dev

# ================================
# Stage 2: Production
# ================================
FROM node:18-alpine AS production

# Usuario no root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copiar dependencias instaladas desde el stage builder
COPY --from=builder /app/node_modules ./node_modules

# Copiar código fuente
COPY . .

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 8081

CMD ["node", "server.js"]
