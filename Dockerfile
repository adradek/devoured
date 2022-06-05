FROM ruby:2.7.6
LABEL maintainer="alex.kochurov@gmail.com"

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  apt-transport-https

# Latest Package for Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
  tee /etc/apt/sources.list.d/yarn.list

# Install packages
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  nodejs \
  yarn

WORKDIR /usr/src/app

# COPY Gemfile* ./
# RUN bundle install

COPY . /usr/src/app/
RUN useradd -ms /bin/bash alexey

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
