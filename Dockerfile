FROM ruby:2.6.1-alpine3.9

RUN mkdir -p /opt/www/myapp
WORKDIR /opt/www/myapp

ENV PASSENGER_VERSION="6.0.1"
ENV PATH="/opt/passenger/bin:$PATH"
ENV VERBOSE=1

RUN apk add --no-cache --update \
  ca-certificates \
  procps \
  curl \
  pcre \
  libstdc++ \
  libexecinfo \
  build-base \
  curl-dev \
  linux-headers \
  pcre-dev \
  libexecinfo-dev

RUN mkdir -p /opt && \
    curl -L https://s3.amazonaws.com/phusion-passenger/releases/passenger-$PASSENGER_VERSION.tar.gz | tar -xzf - -C /opt && \
    mv /opt/passenger-$PASSENGER_VERSION /opt/passenger && \
    export EXTRA_PRE_CFLAGS='-O' EXTRA_PRE_CXXFLAGS='-O' EXTRA_LDFLAGS='-lexecinfo' && \
    # compile agent
    passenger-config compile-agent --auto --optimize && \
    passenger-config install-standalone-runtime --auto --url-root=fake --connect-timeout=60 && \
    passenger-config build-native-support && \
    passenger-config validate-install --auto
