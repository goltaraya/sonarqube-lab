FROM node:alpine
RUN mkdir /usr/app
WORKDIR /usr/app
COPY ./package.json ./
RUN npm install
COPY ./ ./
CMD [ "npm", "start" ]