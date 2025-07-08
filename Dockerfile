# ============ Builder Stage ============
FROM node:lts AS builder

# Create and set working directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy package files first (optimizes layer caching)
COPY package*.json ./

# Verify files were copied (debugging)
RUN ls -la

# Install dependencies
RUN npm install

# Copy remaining files
COPY . .

# Build if needed (uncomment if you have a build step)
# RUN npm run build

# ============ Production Stage ============
FROM node:lts-alpine

WORKDIR /usr/src/app

# Copy from builder stage
COPY --from=builder /usr/src/app .

EXPOSE 3000

# Security: Create non-root user
RUN adduser -D appuser && \
    chown -R appuser /usr/src/app

USER appuser

CMD ["node", "index.js"]
