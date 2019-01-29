## Task A - Checksum API

Setup:
```bash
cd checksum_api
mix deps.get
mix run --no-halt
```

Testing:
```bash
# adding number
# POST /numbers
curl -H "Content-Type: application/json" -X POST -d '{"number":1}' http://localhost:4000/numbers

# clearing numbers
# DELETE /numbers
curl -H "Content-Type: application/json" -X DELETE http://localhost:4000/numbers

# calculating checksum
# GET /numbers/checksum
curl http://localhost:4000/numbers/checksum
```

I didn't write tests or add a timeout of 15ms for Checksum API because of time constraints.

For testing I would:
* write unit tests for the GenServer
* write integration tests for the API endpoints

For the timeout, inside the `NumberStore` genserver I would have wrapped the checksum calculation in a task and use [Task.yield/2](https://hexdocs.pm/elixir/Task.html#yield/2) to return `{:error, :timeout}` instead of `{:ok, checksum}` and within my controller return a `504` error.

## Task B

Written in [Ruby](https://www.ruby-lang.org/en/)

```
cd task_b
ruby checksum_test_client.rb test_input.txt
```
