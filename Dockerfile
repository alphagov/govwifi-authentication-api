FROM ruby:3.0.1-alpine
ARG BUNDLE_INSTALL_CMD
ENV RACK_ENV=development

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock .ruby-version ./
RUN apk --no-cache add --virtual .build-deps build-base && \
  apk --no-cache add mysql-dev && \
  ${BUNDLE_INSTALL_CMD} && \
  apk del .build-deps

COPY . .

CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "8080"]
