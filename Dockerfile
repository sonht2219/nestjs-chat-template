FROM node:20-alpine as builder

ENV NODE_ENV build

USER node
WORKDIR /var/www/html/chatbox-gateway

COPY package*.json ./
RUN npm ci

COPY --chown=node:node . .
RUN npm run build \
    && npm prune --omit=dev

# ---

FROM node:20-alpine

ENV NODE_ENV production

USER node
WORKDIR /var/www/html/chatbox-gateway

COPY --from=builder --chown=node:node /var/www/html/chatbox-gateway/package*.json ./
COPY --from=builder --chown=node:node /var/www/html/chatbox-gateway/node_modules/ ./node_modules/
COPY --from=builder --chown=node:node /var/www/html/chatbox-gateway/dist/ ./dist/

CMD ["node", "dist/main.js"]
