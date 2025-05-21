# Use Bun as the base image
FROM oven/bun:latest

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN bun install

# Copy the source code
COPY . .

# Command to run the monitor
CMD ["bun", "run", "index.ts"]