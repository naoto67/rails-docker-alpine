FROM ruby:2.5.3-alpine

ENV LANG C.UTF-8
ENV ROOT_PATH /app

RUN mkdir $ROOT_PATH
WORKDIR $ROOT_PATH

COPY ./app/Gemfile $ROOT_PATH/Gemfile
COPY ./app/Gemfile.lock $ROOT_PATH/Gemfile.lock

ENV RUNTIME_PACKAGES="bash libxml2-dev libxslt-dev libstdc++ tzdata mysql-client mysql-dev nodejs ca-certificates"
ENV DEV_PACKAGES="build-base"

RUN apk add --update --no-cache $RUNTIME_PACKAGES &&\
    apk add --update\
    --virtual build-dependencies\
    --no-cache\
    $DEV_PACKAGES &&\
    gem install bundler --no-document &&\
    bundle config build.nokogiri --use-system-libraries &&\
    bundle install &&\
    apk del build-dependencies

COPY ./app $ROOT_PATH

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
