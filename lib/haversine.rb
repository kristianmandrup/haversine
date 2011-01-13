#
# haversine formula to compute the great circle distance between two points given their latitude and longitudes
#
# Copyright (C) 2008, 360VL, Inc
# Copyright (C) 2008, Landon Cox
#
# http://www.esawdust.com (Landon Cox)
# contact:
# http://www.esawdust.com/blog/businesscard/businesscard.html
#
# LICENSE: GNU Affero GPL v3
# The ruby implementation of the Haversine formula is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License version 3 as published by the Free Software Foundation. 
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public
# License version 3 for more details.  http://www.gnu.org/licenses/
#
# Landon Cox - 9/25/08
#
# Notes:
#
# translated into Ruby based on information contained in:
#   http://mathforum.org/library/drmath/view/51879.html  Doctors Rick and Peterson - 4/20/99
#   http://www.movable-type.co.uk/scripts/latlong.html
#   http://en.wikipedia.org/wiki/Haversine_formula
#
# This formula can compute accurate distances between two points given latitude and longitude, even for
# short distances.
 
# PI = 3.1415926535 

require 'haversine/core_ext'

class Haversine

  RAD_PER_DEG = 0.017453293  #  PI/180
 
  # this is global because if computing lots of track point distances, it didn't make 
  # sense to new a Hash each time over potentially 100's of thousands of points

  class << self            
    def units 
      [:miles, :km, :feet, :meters]
    end
  end
    
  class Distance
    attr_reader :distance

    def initialize distance
      @distance = distance
    end
    
    def [] key               
      method = :"delta_#{key}"
      raise ArgumentError, "Invalid unit key #{key}" if !respond_to? method
      Distance.send "in_#{key}", send(method)
    end

    Haversine.units.each do |unit|
      class_eval %{
        def #{unit}
          self[:#{unit}]
        end
      }
    end

    protected

    # the great circle distance d will be in whatever units R is in

    Rmiles = 3956           # radius of the great circle in miles
    Rkm = 6371              # radius in kilometers...some algorithms use 6367
    Rfeet = Rmiles * 5282   # radius in feet
    Rmeters = Rkm * 1000    # radius in meters
    
    # delta between the two points in miles
    def delta_miles 
      Rmiles * distance
    end
    
    # delta in kilometers
    def delta_km
      Rkm * distance
    end
    
    def delta_feet
      Rfeet * distance
    end
    
    def delta_meters
      Rmeters * distance
    end                  


    class << self            
      Haversine.units.each do |unit|
        class_eval %{
          def in_#{unit} number
            Unit.new :#{unit}, number
          end
        }
      end
    end
    
    class Unit
      attr_accessor :name, :number
      
      def initialize name, number = 0
        @name = name
        @number = number
      end

      def number
        @number.round_to(precision[name])
      end
      
      def to_s
        "#{number} #{name}"
      end
      
      private
      
      def precision
        {
          :feet => 0,
          :meters => 2,
          :km => 4,
          :miles => 4
        }
      end      
    end
  end
 
  # given two lat/lon points, compute the distance between the two points using the haversine formula
  #  the result will be a Hash of distances which are key'd by 'mi','km','ft', and 'm'
 
  def self.distance( lat1, lon1, lat2, lon2, units = :meters ) 
    dlon = lon2 - lon1
    dlat = lat2 - lat1

    a = calc(dlat, lat1, lat2, dlon)
    c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a))

    Distance.new c
  end  

  def self.calc dlat, lat1, lat2, dlon
    (Math.sin(dlat.rpd/2))**2 + Math.cos(lat1.rpd) * Math.cos((lat2.rpd)) * (Math.sin(dlon.rpd/2))**2    
  end
  
  def self.wants? unit_opts, unit
    unit_opts == unit || unit_opts[unit]    
  end
end 