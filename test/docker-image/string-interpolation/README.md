# String interpolation tests

The string interpolation script should be tested with the same Docker image that
will be used in production. Otherwise for example shell incompatibilities might
cause issues.

All tests will be executed by running:

```sh
./test.sh
```

Each test is contained in its own directory within this directory. The name of
each test directory signifies the name of the test.

Each test directory should contain the following files:

```sh
expected-exit-status # expected exit status from the string interpolation script
expected-stdout # expected stdout from the string interpolation script
expected-stderr # expected stderr from the string interpolation script
migrations/*.sql # string interpolation input
migrations/*.sql.expected # expected string interpolation output
secrets/* # files containing the strings that replace placeholders
```
