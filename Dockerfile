FROM node:18.12.1-alpine

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ARG LINK=no

RUN adduser -S ory -D -u 10000 -s /bin/nologin

ENV CSRF_COOKIE_NAME ax-csrf-cookie
ENV COOKIE_SECRET bt4rgjykKNxVacHVT94zT34hKQKghNZk
ENV CSRF_COOKIE_SECRET bt4rgjykKNxVacHVT94zT34hKQKghNZk
ENV DANGEROUSLY_DISABLE_SECURE_CSRF_COOKIES true
ENV KRATOS_PUBLIC_URL https://kratos.kandiarobitcoin.com
ENV KRATOS_ADMIN_URL http://localhost:4434

COPY package.json .
COPY package-lock.json .

RUN npm ci --fetch-timeout=600000

COPY . /usr/src/app

RUN if [ "$LINK" == "true" ]; then (cd ./contrib/sdk/generated; rm -rf node_modules; npm ci; npm run build); \
    cp -r ./contrib/sdk/generated/* node_modules/@ory/kratos-client/; \
    fi

RUN npm run build

USER 10000

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["npm run serve"]

EXPOSE 3000
