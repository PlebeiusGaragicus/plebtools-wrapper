## ORIG VERSION WITH RUST


# FROM alpine:3.17

# RUN apk update
# RUN apk add --no-cache tini && \
#     rm -f /var/cache/apk/*

# ARG ARCH
# ADD ./plebtools/target/${ARCH}-unknown-linux-musl/release/plebtools /usr/local/bin/plebtools
# RUN chmod +x /usr/local/bin/plebtools
# ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
# RUN chmod a+x /usr/local/bin/docker_entrypoint.sh




# https://github.com/Start9Labs/cryptpad-wrapper/blob/master/Dockerfile

# Stage 1: Build
# FROM node:14-buster AS build
FROM node:16-alpine AS build
WORKDIR /app

# Install other build dependencies
# RUN apt-get update && \
#     apt-get install -y g++ make \
#     libcairo2-dev libjpeg-dev libpango1.0-dev libgif-dev build-essential
# RUN apk update && \
#     apk add g++ make libcairo2-dev libjpeg-dev libpango1.0-dev libgif-dev build-essential
RUN apk update
RUN apk add --no-cache g++ make cairo-dev jpeg-dev pango-dev giflib-dev
RUN apk add --no-cache --virtual .build-deps python3 build-base

# Install dependencies
COPY plebtools/package.json plebtools/package-lock.json ./
# RUN npm ci
RUN npm config set loglevel info
RUN npm install --omit=dev

# Copy application files
COPY plebtools/. .

# Build the application if needed (e.g., transpile TypeScript or other build steps)
# RUN npm run build

# Stage 2: Final image
# FROM node:14-buster-slim
FROM node:16-alpine
WORKDIR /app

# Install tini, et cetra
# RUN apt-get update && apt-get install -y bash curl nginx tini yq && \
# rm -f /var/cache/apk/*

# RUN apk add --no-cache bash curl nginx tini yq && \
#     rm -f /var/cache/apk/*

RUN apk add --no-cache bash curl nginx tini
RUN apk add --no-cache python3 py3-pip
RUN pip install yq
RUN rm -f /var/cache/apk/*

# Copy the node_modules from the build stage
COPY --from=build /app/node_modules /app/node_modules

# Copy the application files from the build stage
COPY --from=build /app /app

# entrypoint
ADD docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod +x /usr/local/bin/docker_entrypoint.sh

# health check
ADD ./check-web.sh /usr/local/bin/check-web.sh
RUN chmod +x /usr/local/bin/check-web.sh

# Expose the application port
EXPOSE 3000

# Set the entrypoint.sh script as the entry point
# ENTRYPOINT ["./docker_entrypoint.sh"]
# ENTRYPOINT ["/app/docker_entrypoint.sh"]
