FROM ruby:4.0.2-slim AS bundle

ENV BUNDLE_DEPLOYMENT=true
ENV BUNDLE_PATH=/usr/local/bundle

WORKDIR /app

RUN apt-get update \
  && apt-get install --yes --no-install-recommends build-essential \
  && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./

RUN gem install bundler:4.0.10 \
  && bundle install

FROM ruby:4.0.2-slim

ENV BUNDLE_DEPLOYMENT=true
ENV BUNDLE_PATH=/usr/local/bundle

WORKDIR /workspace

COPY --from=bundle /usr/local/bundle /usr/local/bundle
COPY . /workspace

RUN useradd --create-home app \
  && chown -R app:app /workspace

USER app

ENTRYPOINT ["bundle", "exec", "bin/toolkit"]
