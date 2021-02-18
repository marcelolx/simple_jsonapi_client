FROM ruby:2.6.6

RUN postgresqlDeps='wget gnupg' \
  set -x \
  && apt-get update \
  && apt-get install -y $postgresqlDeps --no-install-recommends \
  && wget --quiet -O - https://deb.nodesource.com/setup_10.x | bash - \
  && echo 'deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' >  /etc/apt/sources.list.d/pgdg.list \
  && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && apt-get update \
  && apt-get install -y tzdata postgresql-client-12 --no-install-recommends \
  && gem update --system; gem install bundler \
  && bundle config --global frozen 1

RUN mkdir /jsonapi_app
ENV BUNDLER_VERSION=2.2.9
WORKDIR /jsonapi_app
ADD Gemfile /jsonapi_app/Gemfile
ADD Gemfile.lock /jsonapi_app/Gemfile.lock
RUN bundle install
ADD . /jsonapi_app
