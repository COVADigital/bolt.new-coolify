# Base image for the project
ARG BASE=node:20.18.0
FROM ${BASE} AS base

WORKDIR /app

# Install dependencies (cached as long as the dependencies don't change)
COPY package.json pnpm-lock.yaml ./

RUN corepack enable pnpm && pnpm install

# Copy the rest of your app's source code
COPY . .

# Expose the port the app runs on
EXPOSE 5173

# Ensure `bindings.sh` is executable
RUN chmod +x ./bindings.sh

# --------------------------
# Production Image
# --------------------------
FROM base AS bolt-ai-production

# Set environment for production
ENV NODE_ENV=production

# Pre-configure wrangler to disable metrics (Coolify-compatible)
RUN mkdir -p /root/.config/.wrangler && \
    echo '{"enabled":false}' > /root/.config/.wrangler/metrics.json

# Build the application for production
RUN pnpm run build

# Default command for production environment
CMD ["pnpm", "run", "dockerstart"]

# --------------------------
# Development Image
# --------------------------
FROM base AS bolt-ai-development

# Set environment for development
ENV NODE_ENV=development

# Create a directory for runtime files
RUN mkdir -p ${WORKDIR}/run

# Expose the development port
EXPOSE 5174

# Default command for development environment
CMD ["pnpm", "run", "dev", "--host", "0.0.0.0"]
