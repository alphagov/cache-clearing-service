ARG base_image=ghcr.io/alphagov/govuk-ruby-base:3.1.2
ARG builder_image=ghcr.io/alphagov/govuk-ruby-builder:3.1.2

FROM $builder_image AS builder

WORKDIR $APP_HOME
COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle install
COPY . ./


FROM $base_image

ENV GOVUK_APP_NAME=cache-clearing-service
ENV GOVUK_ENV=deployment

WORKDIR $APP_HOME
COPY --from=builder $BUNDLE_PATH/ $BUNDLE_PATH/
COPY --from=builder $APP_HOME ./
ENTRYPOINT ["rake", "message_queue:consumer"]
CMD ["QUEUE=high"]
