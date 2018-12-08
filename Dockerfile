FROM ruby:2.1-onbuild
MAINTAINER Justin Downing <justin@downing.us>

ENV PUPPET_VERSION="4.10.0" FIXTURES_YML=".puppet4.fixtures.yml"

RUN bundle install --without development
RUN bundle exec rake spec SPEC_OPTS='--format documentation' PARSER='future'
