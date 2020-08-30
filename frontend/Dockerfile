from node:10.19.0-alpine 

WORKDIR /usr/src/frontend

COPY package.json .
COPY package-lock.json .

RUN npm install 

COPY . .
