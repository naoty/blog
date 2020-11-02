FROM ruby:2.7.2-alpine3.12
WORKDIR /root/blog
COPY Gemfile Gemfile.lock ./
RUN bundle install
