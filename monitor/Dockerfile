FROM node:22-alpine

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./

# Install both production and dev dependencies
RUN npm install && npm install -g typescript ts-node

# Bundle app source
COPY . .

# Compile TypeScript
RUN npm run build

# Create a non-root user and switch to it
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN chown -R appuser:appgroup /usr/src/app
USER appuser

# Run the app
CMD [ "node", "dist/monitor.js" ]