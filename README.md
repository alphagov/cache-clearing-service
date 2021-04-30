# Cache Clearing Service

A message queue consumer application which clears Fastly and Varnish caches when new content is published. Messages are read from the `published_documents` exchange which carries documents published from all publishing applications.

## Technical documentation

### Running the application

```sh
$ bin/cache_clearing_service
```

### Running the test suite

```sh
$ bundle exec rspec
```

## Licence

[MIT Licence](LICENCE.md)
