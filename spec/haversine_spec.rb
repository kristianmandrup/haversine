require 'spec_helper'

describe "Haversine" do
  it "should work" do
    lon1 = -104.88544
    lat1 = 39.06546

    lon2 = -104.80
    lat2 = lat1

    dist = Haversine.distance( lat1, lon1, lat2, lon2 )

    puts "the distance from  #{lat1}, #{lon1} to #{lat2}, #{lon2} is: #{dist[:meters].number} meters"

    puts "#{dist[:feet]}"
    puts "#{dist.meters}"
    puts "#{dist[:km]}"
    puts "#{dist[:miles]}"
    dist[:km].to_s.should match(/7\.376*/)
  end
end
