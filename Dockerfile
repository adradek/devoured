FROM ruby:3.4
LABEL maintainer="alex.kochurov@gmail.com"

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  curl \
  gnupg \
  ca-certificates \
  nano \
  nodejs \
  apt-transport-https \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get remove -yqq --purge git

RUN curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg \
  | gpg --dearmor -o /usr/share/keyrings/yarn-archive-keyring.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/yarn-archive-keyring.gpg] https://dl.yarnpkg.com/debian stable main" \
  | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends yarn \
  && rm -rf /var/lib/apt/lists/*

# Install packages
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  nano \
  nodejs

WORKDIR /usr/src/app

# COPY Gemfile* ./
# RUN bundle install

COPY . /usr/src/app/
RUN useradd -ms /bin/bash alexey
USER alexey

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
