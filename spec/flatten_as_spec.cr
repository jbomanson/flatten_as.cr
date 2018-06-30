require "./spec_helper"

describe FlattenAs do
  describe "skeleton" do
    it "turns a flat array to a flat array" do
      FlattenAs.skeleton([2, 4, 1, 3], Array(Int32))
               .should eq([] of Int32)
    end

    it "turns a flat array of one type to a flat array of another type" do
      FlattenAs.skeleton([2, 4, 1, 3], Array(Float32))
               .should eq([] of Float32)
    end

    it "turns a flat array to a flat set with identical elements" do
      FlattenAs.skeleton([2, 4, 1, 3], Set(Int32))
               .should eq(Set.new([] of Int32))
    end

    it "turns a heterogeneous nested array to a flat array" do
      FlattenAs.skeleton([2, [4, [1]], [[3]]], Array(Int32))
               .should eq([] of Int32)
    end

    it "turns a simple nested array to an array of depth 2" do
      FlattenAs.skeleton([[1], [[2]], [[[3]]]], Array(Array(Int32)))
               .should eq([[] of Int32, [] of Int32, [] of Int32])
    end

    it "turns a simple nested array to an array of depth 3" do
      FlattenAs.skeleton([[[[2]], [[[3]]]]], Array(Array(Array(Int32))))
               .should eq([[[] of Int32, [] of Int32]])
    end

    it "turns a nested array to an array of depth 2" do
      FlattenAs.skeleton([[4, [1]], [[3]]], Array(Array(Int32)))
               .should eq([[] of Int32, [] of Int32])
    end

    it "turns a flat array into an array with a union element type" do
      FlattenAs.skeleton([2, 4, 1, 3], Array(Int32 | Float32))
               .should eq([] of Int32 | Float32)
    end

    it "turns a flat array into an array with a union element type involving arrays" do
      FlattenAs.skeleton([2, 4, 1, 3], Array(Int32 | Array(Int32)))
               .should eq([] of Int32 | Array(Int32))
    end

    # In a case like this, where a union type includes an Enumerable, the
    # union is treated the same as any non-Enumerable type even if the union
    # contains enumerable types.
    it "turns Array(Int32 | Array) into something" do
      FlattenAs.skeleton([2, [4]], Array(Int32 | Array(Int32)))
               .should eq([] of Int32 | Array(Int32))
    end

    it "turns a complicated array into something sensible in an ambiguous case" do
      FlattenAs.skeleton([2, [4, [1]], [[3]]], Array(Int32 | Array(Int32)))
               .should eq([] of Int32 | Array(Int32))
    end
  end

  describe "Enumerable#flatten_as" do
    it "turns a flat array into an identical flat array" do
      FlattenAs.flatten_as([2, 4, 1, 3], Array(Int32))
               .should eq([2, 4, 1, 3])
    end

    it "turns a flat array to a flat set with identical elements" do
      FlattenAs.flatten_as([2, 4, 1, 3], Set(Int32))
               .should eq(Set.new([2, 4, 1, 3]))
    end

    it "turns a heterogeneous nested array to a flat array" do
      FlattenAs.flatten_as([2, [4, [1]], [[3]]], Array(Int32))
               .should eq([2, 4, 1, 3])
    end

    it "turns a simple nested array to an array of depth 2" do
      FlattenAs.flatten_as([[1], [[2]], [[[3]]]], Array(Array(Int32)))
               .should eq([[1], [2], [3]])
    end

    it "turns a simple nested array to an array of depth 3" do
      FlattenAs.flatten_as([[[[2]], [[[3]]]]], Array(Array(Array(Int32))))
               .should eq([[[2], [3]]])
    end

    it "turns a nested array to an array of depth 2" do
      FlattenAs.flatten_as([[4, [1]], [[3]]], Array(Array(Int32)))
               .should eq([[4, 1], [3]])
    end

    it "turns a nested array to a set of depth 2" do
      FlattenAs.flatten_as([[4, [1]], [[3]]], Set(Set(Int32)))
               .should eq(Set.new([Set.new([4, 1]), Set.new([3])]))
    end

    it "turns Array(Int32 | Array) into something" do
      FlattenAs.flatten_as([2, [4]], Array(Int32 | Array(Int32)))
               .should eq([2, [4]])
    end

    it "turns a complicated array into something sensible in an ambiguous case" do
      FlattenAs.flatten_as([2, [4, [1]], [[3]]], Array(Int32 | Array(Int32)))
               .should eq([2, 4, [1], [3]])
    end

    it "flattens a deep array by one level" do
      array = [[2, [4], [[1]], [[3]]]]
      FlattenAs.flatten_as(array, typeof(array.first))
               .should eq([2, [4], [[1]], [[3]]])
    end

    it "flattens a deep array by two levels" do
      array = [[[2, [4], [[1]], [[3]]]]]
      FlattenAs.flatten_as(array, typeof(array.first.first))
               .should eq([2, [4], [[1]], [[3]]])
    end
  end
end
