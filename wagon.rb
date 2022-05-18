require_relative 'company'
require_relative 'validation'

class Wagon
  include Company
  include Validation

  attr_reader :type, :total_place, :used_place

  validate :type, :presence

  def initialize(type, total_place)
    @type = type
    @total_place = total_place
    @used_place = 0
  end

  def free_place
    total_place - used_place
  end
end
