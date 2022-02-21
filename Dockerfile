FROM ruby:3.1.1-alpine3.15
RUN apk add --update build-base
WORKDIR /root/blog
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . ./
ENTRYPOINT ["bin/blog"]
