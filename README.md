# MarvelGateway

Elixir micro-service app for processing requests based on MarvelAPI integration, includes API authentication & DB transactions.

### Dependencies

  * Make sure you have `Erlang` and `Elixir` installed:
    - Erlang >= v20
    - Elixir >= 1.10

### Getting Started

  * Setup the repository

    ```
    $ git clone git@github.com:BrandonTruter/marvel_gateway.git
    $ cd marvel_gateway
    ```

  * Install & compile the dependencies

    ```
    $ mix do deps.get, deps.compile, compile
    ```

  * Create & migrate the database

    ```
    $ mix ecto.create && mix ecto.migrate
    $ mix run priv/repo/seeds.exs
    ```

  * Start the server with `$ mix phx.server`

  Now we can receive API requests on [`localhost:4000`](http://localhost:4000)


### Usage

With the server up and running, you can run the following CURL  commands in another terminal for testing API requests

**Characters** API via  `GET /api/v1/characters`
```bash
$ curl --request GET \
       --url 'http://localhost:4000/api/v1/characters' \
       --header 'apikey: 5f3ca374aec85caae447eff6ff94fed3' \
       --header 'Content-Type: application/json'
```

**Character** API via `GET /api/v1/characters/:id`

```bash
$ curl --request GET \
       --url 'http://localhost:4000/api/v1/characters/1009368' \
       --header 'apikey: 5f3ca374aec85caae447eff6ff94fed3' \
       --header 'Content-Type: application/json'
```

**Series** API via  `GET /api/v1/series/:id`

```bash
$ curl --request GET \
       --url 'http://localhost:4000/api/v1/series/1009368' \
       --header 'apikey: 5f3ca374aec85caae447eff6ff94fed3' \
       --header 'Content-Type: application/json'
```




Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
