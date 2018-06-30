# flatten_as

Adds `Enumerable#flatten_as` that is like `flatten` with compile time control
over what is flattened.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  flatten_as:
    github: jbomanson/flatten_as
```

## Usage

This library adds the following method to `Enumerable`:

```crystal
def flatten_as(target_type : U.class) : U forall U
```

Flattens self partially and converts the result into an enumerable of type
`U`.

```crystal
require "flatten_as"

# Flattening into a one dimensional array.
[2, [4, [1]], [[3]]].flatten_as(Array(Int32)) # => [2, 4, 1, 3]

# Flattening into a two dimensional array.
[[4, [1]], [[3]]].flatten_as(Array(Array(Int32))) # => [[4, 1], [3]]

# Flattening into a two dimensional set.
[[4, [1]], [[3]]].flatten_as(Set(Set(Int32))) # => Set{Set{4, 1}, Set{3}}

# Casting elements.
[2, 4, 1, 3].flatten_as(Array(Int32 | Float32)) # => [2, 4, 1, 3]
```

More specifically, this flattening works as follows.

Suppose self is a type similar to `Array(Indexable(Set(Iterator(X))))`.
In general, it can be any type starting with some number of nested
`Enumerable` types.
The last type, `X`, can be anything other than a plain Enumerable type.
In other words, it can be an Int32 or some union type for example, even if
that union type includes an Enumerable.

The target type `U` must also an Enumerable.
Suppose it is `Set(Array(Y))`.
The important thing here is that all the Enumerable types that `U` begins
with must be constructible with a `new` method that takes no arguments and
must respond to a `<<` method.
The last type, `Y`, is again anything other than a plain Enumerable type.

In this setting, the flattening method will:

- cast the non Enumerable part `X` of self as `Y`

- flatten the Enumerable part of self that extends beyond `U` in depth,
  namely `Set(Iterator(...))`

- recreate the leading Enumerable part of self that is as deep as `U` as an
  instance of the target type, which in this case means to recreate
  `Array(Indexable(...))` as `Set(Array(Y))`.

## Contributing

1. Fork it ( https://github.com/jbomanson/flatten_as/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [jbomanson](https://github.com/jbomanson) Jori Bomanson - creator, maintainer
