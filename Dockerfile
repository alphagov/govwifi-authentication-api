FROM ruby:2.5.3-alpine
ARG BUNDLE_INSTALL_CMD
ENV RACK_ENV=development

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock .ruby-version ./
RUN apk --no-cache add build-base mysql-dev && \
  ${BUNDLE_INSTALL_CMD} && \
  apk del build-base

COPY . .

CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "8080"]
