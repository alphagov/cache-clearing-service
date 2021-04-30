# Cache Clearing Service

A message queue consumer application which clears Fastly and Varnish caches when new content is published. Messages are read from the `published_documents` exchange which carries documents published from all publishing applications.

## Technical documentation

You can use the [GOV.UK Docker environment](https://github.com/alphagov/govuk-docker) to run the tests. Follow [the usage instructions](https://github.com/alphagov/govuk-docker#usage) to get started.

**Use GOV.UK Docker to run any commands that follow.**

### Running the test suite

```sh
bundle exec rake
```

## Licence

[MIT Licence](LICENCE.md)
