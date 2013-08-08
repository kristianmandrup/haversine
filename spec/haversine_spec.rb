require 'spec_helper'

describe Haversine do
  describe "#self.distance" do
    it "returns Haversine::Distance" do
      Haversine.distance(0,0,0,0).should be_a(Haversine::Distance)
    end
    
    it "accepts 4 numbers or 2 arrays as arguments" do
      new_york_city = [40.71427, -74.00597]
      santiago_chile = [-33.42628, -70.56656]
      point_dist = Haversine.distance(new_york_city[0], new_york_city[1], santiago_chile[0], santiago_chile[1])
      array_dist = Haversine.distance(new_york_city, santiago_chile)
      
      point_dist.should be_a(Haversine::Distance)
      array_dist.should be_a(Haversine::Distance)
      point_dist.to_m.should == array_dist.to_m
    end

    it "computes nautical mile distances correctly" do
      new_york_city = [40.71427, -74.00597]
      santiago_chile = [-33.42628, -70.56656]
      dist = Haversine.distance(new_york_city, santiago_chile)
      dist.to_miles.should eq(5123.736179853891)
      dist.to_nautical_miles.should eq(4452.402874445064)
    end

    it "calculates the distance between the provided lat/lon pairs" do
      Haversine.distance(0,0,0,0).to_miles.should == 0
      round_to(6, Haversine.distance(0,0,0,360).to_miles).should == 0
      round_to(6, Haversine.distance(0,0,360,0).to_miles).should == 0
    end
  end
  
  # Helpers
  def round_to(precision, num)
    (num * 10**precision).round.to_f / 10**precision
  end
end
