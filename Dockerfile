# Étape 1 - on installe tout et on compile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Étape 2 - image finale légère, seulement ce qui est nécessaire
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production    # seulement les dépendances de prod
COPY --from=builder /app/dist ./dist
EXPOSE 3000
CMD ["node", "dist/main.js"]