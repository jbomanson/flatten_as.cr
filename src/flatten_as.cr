require "./flatten_as/enumerable"

# A module with one method, `flatten_as`.

# :nodoc:
module FlattenAs
  # Does only the Enumerable recreation part of `flatten_as` and does not
  # populate the constructed Enumerable objects with any elements of the
  # original object.
  #
  # This is useful in testing.
  def self.skeleton(object, target_type : U.class) : U forall U
    sink = [] of U
    Create(typeof(object), U, Noop).create(object, sink)
    sink.first
  end

  # The same as `Enumerable#flatten_as` called on `object`.
  def self.flatten_as(object, target_type : U.class) : U forall U
    sink = [] of U
    Create(typeof(object), U, FlattenTo(typeof(object), U)).create(object, sink)
    sink.first
  end

  private module Create(S, T, O)
    def self.create(object : Enumerable, sink : Enumerable(Enumerable)) : Nil
      new_sink = typeof(sink.first).new
      sink << new_sink
      object.each { |elem| create(elem, new_sink) }
    end

    def self.create(object, sink : Enumerable(Enumerable)) : Nil
      {{ raise "Can not flatten #{S} to #{T}" }}
    end

    def self.create(object, sink) : Nil
      O.flatten_to(object, sink)
    end
  end

  private module Noop
    def self.flatten_to(object, sink) : Nil
    end
  end

  private module FlattenTo(S, T)
    def self.flatten_to(object, sink : Enumerable(U)) : Nil forall U
      case object
      when U
        sink << object
      when Enumerable, Iterator
        object.each { |elem| flatten_to(elem, sink) }
      else
        can_not_flatten(object)
      end
    end

    def self.can_not_flatten(object)
      {{ raise "Can not flatten #{S} to #{T}" }}
    end
  end
end
