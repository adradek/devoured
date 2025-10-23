FROM ruby:3.1
LABEL maintainer="alex.kochurov@gmail.com"

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  apt-transport-https

RUN apt-get remove -yqq --purge git

# Add the Debian backports repository
# RUN echo "deb http://deb.debian.org/debian bullseye-backports main" > /etc/apt/sources.list.d/backports.list
# RUN apt-get update && \
#    apt-get install -yqq git/bullseye-backports

# Latest Package for Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
  tee /etc/apt/sources.list.d/yarn.list

# Install packages
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  nano \
  nodejs \
  yarn

WORKDIR /usr/src/app

# COPY Gemfile* ./
# RUN bundle install

COPY . /usr/src/app/
RUN useradd -ms /bin/bash alexey

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
