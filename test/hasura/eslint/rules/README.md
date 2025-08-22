# This directory

This directory contains a copy of out TypeScript eslint rule setup.
This directory is a copy of the one found in the [Jore4 UI repo][uiRepo].
These should preferably be kept in sync.

# Differences

- React stuff dropped
- Different index file to only provide what is needed.

# Original README

This started as copy of [eslint-config-airbnb](https://www.npmjs.com/package/eslint-config-airbnb)
but has since been cleanup to remove duplicate rule configs as per the other
plugins included/extended by the Airbnb config.
Additionally, our own overrides have been applied directly ontop the rulesets to
keep the config as clean as possible, i.e. have a single source of truth for
each ESLint rule.

The old MIT license file is kept in place and applies to those lines of code
included in the original copy commit (87bcf8caf03343e03034c7f15dd741d3f410d4d0).

[uiRepo]: https://github.com/HSLdevcom/jore4-ui/blob/main/eslint/rules
