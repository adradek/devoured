FROM ruby:2.5
LABEL maintainer="alex.kochurov@gmail.com"

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  nodejs

WORKDIR /usr/src/app

# COPY Gemfile* ./
# RUN bundle install

COPY . /usr/src/app/
RUN useradd -ms /bin/bash alexey

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
