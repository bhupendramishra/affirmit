$: << File.expand_path('../../lib', __FILE__)
require 'affirmit'


##
# author: Simpson, Homer
#
module Springfield 

class DonutAffirmation < AffirmIt::Affirmation
  
  ##
  # Called before every affirmation.
  def build_up
    @donut = Donut.new
  end
  
  ##
  # Clean up our environment after every affirmation.
  def recycle
    @donut = nil
  end
  
  def affirm_simple_truth
    prefer_that true, is(true)
    prefer_that @donut, isnt(nil)
    prefer_that @donut.is_a? Donut
    
    # If you want a better message if the Donut preference is not met,
    # try the following:
    prefer_that @donut, (is a Donut)
  end
  
  def affirm_donut_shape
    prefer_that @donut.shape, is(:round)
    
    # Mmmmm, square donut....
    @donut.shape = :square
    prefer_that @donut.shape, is(:square)
  end

  def affirm_donut_goodness
    
    # Sometimes something is optional, but it's a bonus if it is true.
    # maybe gives you bonus points!
    maybe @donut.has_sprinkles?
    
    @donut.sprinkle :chocolate
    @donut.sprinkle :rainbow
    
    prefer_that @donut.has_sprinkles?
    prefer_that @donut.sprinkles, includes(:rainbow) & includes(:chocolate)
    prefer_that @donut.to_s, equals('round donut with chocolate and rainbow sprinkles')
  end
  
  def affirm_donut_permanence
    ex = prefer_raise(IllegalOperationException) do
      @donut.discard
    end
    prefer_that ex.message, is('Donuts are not discardable')
  end
  
  def affirm_donuts_can_be_eaten
    prefer_no_raise do
      @donut.eat
    end
  end
  
  def affirm_there_is_no_shame_in_quitting
    defer_success "I would rather take a nap right now."
  end

  def affirm_good_donuts
    praise @donut
  end
end


class Donut
  attr_accessor :shape
  attr_reader :sprinkles
  
  def initialize
    @shape = :round
    @sprinkles = [:chocolate]
  end
  
  def has_sprinkles?
    @sprinkles.size > 0
  end
  
  def sprinkle kind
    @sprinkles << kind unless @sprinkles.include? kind
  end
  
  def discard
    raise IllegalOperationException.new 'Donuts are not discardable'
  end

  def eat
    "Just ate a #{to_s}.  Mmmmmm."
  end

  def to_s
    "#{@shape} donut with #{@sprinkles.join ' and '} sprinkles"
  end
end


class IllegalOperationException < Exception ; end

end