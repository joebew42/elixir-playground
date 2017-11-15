# EctoExamples

A collection of [Ecto](https://github.com/elixir-ecto/ecto) examples

## Requirements

This example will use `PostgreSQL`. You need to run it:

```
docker run -it --rm=true --name ecto-postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres:alpine
```

## Setup

```
mix deps.get
```

## Create the database

```
mix ecto.create
```

## Run migrations

```
mix ecto.migrate
```

## Run tests

```
mix test --trace
```

## Drop the database

```
mix ecto.drop
```
