# Cache Clearing Service

This is a message queue consumer application which clears Fastly and Varnish
caches when new content is published.

## Technical documentation

Messages are read from the `published_documents` exchange which carries
documents published from all publishing applications.

When the service detects a published document it clears the cache in Fastly and
Varnish for that path.

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
