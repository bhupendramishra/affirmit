require 'affirmit/esteem'
require 'affirmit/grouphug'

module AffirmIt
  class Affirmation
    include Esteem
    
    ##
    # These issues are not raised to the facilitator by #embrace.
    # Recycled from Test::Unit.
    PASSTHROUGH_EXCEPTIONS = [NoMemoryError, SignalException, Interrupt, SystemExit]
    
    attr_reader :method_name
    
    def initialize(method_name)
      # Ruby syntax note: If we don't put the parentheses here,
      # it calls the super's initialize method with all the
      # parameters supplied to this method.  However,
      # Esteem.initialize takes no parameters, so I have to
      # explicitly pass it no parameters.
      super()
      @method_name = method_name
    end
    
    class << self
      
      ##
      # Collects all the individual affirmations in this class
      # into a big group hug.
      def group_hug
        group_hug = GroupHug.new(name) # name = class name
        public_instance_methods(true).sort.each do |method_name|
          if method_name =~ /^affirm[^A-Za-z0-9]/
            group_hug << new(method_name)
          end
        end
        group_hug
      end
      
    end
    
    ##
    # Affirmations may want to build themselves up before they
    # are embraced by a facilitator.  If so, they should inherit
    # and more fully define the build_up method.
    def build_up
    end
    
    ##
    # After being embraced, whether their opinions are preferred
    # by the facilitator or not, affirmations should take care
    # of their environment and recycle any resources that they
    # have consumed when building themselves up.  In order to do
    # so, they should inherit and define the recycle method.
    def recycle
    end
    
    def affirmation_count
      1
    end
    
    def name
      "#{self.class.name}.#{@method_name}"
    end
    
    def add_preference
      @facilitator.add_preference
    end
    
    def add_bonus_point
      @facilitator.add_bonus_point
    end
    
    def praise object, msg = ''
      @facilitator.praise "What a wonderful #{object}!  #{msg}"
    end
    
    def embrace facilitator
      @facilitator = facilitator
      success = false
      facilitator.with_arms_around self do
        begin
          build_up
          __send__ @method_name
          success = true
        rescue DifferingOpinion => opinion
          facilitator.espouse_differing_opinion opinion
        rescue ElectiveDeferral => deferral
          facilitator.defer_success deferral
        rescue IntolerantPig => pig
          facilitator.expel pig
        rescue BehavioralChallenge => challenge
          facilitator.admit_challenge challenge
        rescue Exception => e
          raise e if PASSTHROUGH_EXCEPTIONS.include? e.class
          facilitator.raise_issue e
        ensure
          begin
            recycle
            facilitator.cherish_affirmation if success
          rescue DifferingOpinion => opinion
            facilitator.espouse_differing_opinion opinion
          rescue ElectiveDeferral => deferral
            facilitator.defer_success deferral
          rescue IntolerantPig => pig
            facilitator.expel pig
          rescue BehavioralChallenge => challenge
            facilitator.admit_challenge challenge
          rescue Exception => e
            raise e if PASSTHROUGH_EXCEPTIONS.include? e.class
            facilitator.raise_issue e
          end
        end
      end
      
      facilitator.add_affirmation
      @facilitator = nil
    end
  end
end
