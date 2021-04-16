FROM ruby:3.0.1-alpine3.13
RUN apk add --update build-base
WORKDIR /root/blog
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . ./
ENTRYPOINT ["bin/blog"]
