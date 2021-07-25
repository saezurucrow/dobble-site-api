FROM ruby:3.0.0

ENV APP=/app
RUN mkdir -p ${APP}

WORKDIR ${APP}
COPY Gemfile Gemfile.lock ${APP}/

RUN set -x && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends curl less sudo

ENV LANK=C.UTF-8
RUN echo 'Asia/Tokyo' > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

ENV ENTRYKIT_VERSION 0.4.0
RUN set -x && \
  curl -sL https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz | tar zx -C /usr/local/bin --no-same-owner --no-same-permissions && \
  entrykit --symlink

ENV DOCKERIZE_VERSION v0.6.1
RUN set -x && \
  curl -sL https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz | tar zx -C /usr/local/bin --no-same-owner --no-same-permissions

ENV DEPENDENCY="nodejs libpq-dev libsqlite3-dev libssl-dev libgeos-dev" \
  DEV_DEPENDENCY="build-essential"
ENV YARN_VERSION=1.22.4
RUN set -x && \
  curl -sL https://deb.nodesource.com/setup_15.x | bash - && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends ${DEPENDENCY} ${DEV_DEPENDENCY} && \
  bash -c "curl -sL --compressed https://yarnpkg.com/downloads/${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz | tee >(tar zx -C /usr/local/ --strip=1 --wildcards yarn*/bin --no-same-owner --no-same-permissions) | tar zx -C /usr/local/ --strip=1 --wildcards yarn*/lib --no-same-owner --no-same-permissions" && \
  bundle install -j4 && \
  apt-get purge -y ${DEV_DEPENDENCY} && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  truncate -s 0 /var/log/*log

COPY . ${APP}

CMD ["bin/rails", "s", "-b", "0.0.0.0"]