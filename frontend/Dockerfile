from node:10.19.0-alpine 

WORKDIR /usr/src/frontend

COPY package.json .

RUN \
  apk add --no-cache python make g++ && \
  apk add musl-dev zlib make gcc autoconf automake libtool tiff jpeg zlib-dev file pkgconf nasm vips-dev fftw-dev --update-cache \
  --repository http://dl-3.alpinelinux.org/alpine/edge/community \
  --repository http://dl-3.alpinelinux.org/alpine/edge/main \
  && rm -fR /var/cache/apk/*

RUN npm install -g gatsby-cli
RUN npm install

COPY . . 
