# Use lightweight Node.js image
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install --only=production

# Copy app files
COPY . .

# Expose port
EXPOSE 8080

# Set environment variables for proxy
ENV PORT=8080
ENV NODE_ENV=production

# Run the proxy server
CMD ["node", "server.js"]
