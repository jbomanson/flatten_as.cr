require "./spec_helper"

# For more tests, see spec/flatten_as_spec.cr.

describe "Enumerable#flatten_as" do
  it "flattens an array" do
    [2, [4, [1]], 3].flatten_as(Array(Int32)).should eq([2, 4, 1, 3])
  end
end
