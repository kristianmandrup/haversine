require 'spec_helper'

describe Haversine::Distance do
  describe "<=>" do
    context "equality" do
      it "is true when the great circle distance is equal" do
        dist1 = Haversine::Distance.new(0)
        dist2 = Haversine::Distance.new(0)
        expect(dist1 == dist2).to be(true)
      end

      it "is false when the great circle distance is not equal" do
        dist1 = Haversine::Distance.new(0)
        dist2 = Haversine::Distance.new(1)
        expect(dist1 == dist2).to be(false)
      end
    end
  end
end
