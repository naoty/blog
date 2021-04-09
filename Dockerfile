FROM ruby:2.7.3-alpine3.12
RUN apk add --update build-base
WORKDIR /root/blog
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . ./
ENTRYPOINT ["bin/blog"]
