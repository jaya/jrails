require 'active_suport'
module Jrails::RescueFrom
  extend ::ActiveSuport::Concern

  class_methods do 
    def rescue_from(*klasses, &block)
      byebug
      options = klasses.extract_options!
      
    end
  end
end