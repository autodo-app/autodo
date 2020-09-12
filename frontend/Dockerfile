FROM node:12-alpine as builder
# Get the necessary build tools
RUN apk update && apk add build-base autoconf automake libtool pkgconfig nasm

# Add the package.json file and build the node_modules folder
WORKDIR /app
COPY ./package*.json ./
RUN mkdir node_modules && npm install

# Get a clean image with gatsby-cli and the pre-built node modules
FROM node:12-alpine
RUN npm install --global gatsby-cli && gatsby telemetry --disable && mkdir /save
COPY --from=builder /app/node_modules /save/node_modules
