# National Data Catalog

This is front-end web app for the National Data Catalog system.

### Requirements

Other the standard Rails stack, the biggest requirement is the National Data Catalog API, which is a Sinatra app that uses MongoDB as its data store. Please navigate to the [datacatalog-api](http://github.com/sunlightlabs/datacatalog-api) repository to get set up on that end.

    rake gems:install

### Setup

1. Configure `config/api.yml` to point to your API instance.
2. Configure a `config/database.yml` to point to your relational database of choice.
