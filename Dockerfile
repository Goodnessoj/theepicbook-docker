# -------- Stage 1: Builder --------
FROM node:18-alpine AS builder

WORKDIR /app

# Copy dependency files first (for caching)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application source
COPY . .


# -------- Stage 2: Production --------
FROM node:18-alpine

WORKDIR /app

# Set production environment
ENV NODE_ENV=production

# Copy dependency files
COPY package*.json ./

# Install only production dependencies
RUN npm install --only=production

# Copy app from builder stage
COPY --from=builder /app .

# Expose app port
EXPOSE 8080

# Start the app
CMD ["sh", "-c", "sleep 10 && node server.js"]
