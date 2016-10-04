module Haversine
  class Distance
    include Comparable

    GREAT_CIRCLE_RADIUS_MILES = 3956
    GREAT_CIRCLE_RADIUS_KILOMETERS = 6371 # some algorithms use 6367
    GREAT_CIRCLE_RADIUS_FEET = GREAT_CIRCLE_RADIUS_MILES * 5280
    GREAT_CIRCLE_RADIUS_METERS = GREAT_CIRCLE_RADIUS_KILOMETERS * 1000
    GREAT_CIRCLE_RADIUS_NAUTICAL_MILES = GREAT_CIRCLE_RADIUS_MILES / 1.15078

    attr_reader :great_circle_distance

    def initialize(great_circle_distance)
      @great_circle_distance = great_circle_distance
    end

    def to_miles
      @great_circle_distance * GREAT_CIRCLE_RADIUS_MILES
    end
    alias_method :to_mi, :to_miles

    def to_kilometers
      @great_circle_distance * GREAT_CIRCLE_RADIUS_KILOMETERS
    end
    alias_method :to_km, :to_kilometers

    def to_meters
      @great_circle_distance * GREAT_CIRCLE_RADIUS_METERS
    end
    alias_method :to_m, :to_meters

    def to_feet
      @great_circle_distance * GREAT_CIRCLE_RADIUS_FEET
    end
    alias_method :to_ft, :to_feet

    def to_nautical_miles
      @great_circle_distance * GREAT_CIRCLE_RADIUS_NAUTICAL_MILES
    end
    alias_method :to_nm, :to_nautical_miles

    def <=>(other)
      if other.respond_to? :great_circle_distance # it's duck if it quacks
        great_circle_distance <=> other.great_circle_distance
      else
        return nil # spitting out nil when objects are not comparable
      end
    end
  end
end
