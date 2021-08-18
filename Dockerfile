FROM node:lts AS builder
WORKDIR /app

COPY package.json .
COPY yarn.lock .

RUN yarn install --no-progress --non-interactive

COPY .eslintignore .
COPY .eslintrc.js .
COPY webpack.common.js .
COPY webpack.prod.js .
COPY client client

RUN yarn run build

FROM node:lts

WORKDIR /app

COPY package.json .
COPY yarn.lock .

RUN yarn install --production --no-progress --non-interactive

COPY --from=builder /app/dist dist
COPY server server 

ARG app_version
ENV APP_VERSION=$app_version

EXPOSE 3000

USER node

CMD [ "yarn", "run", "start" ]
