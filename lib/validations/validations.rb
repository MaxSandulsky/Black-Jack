# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Validations
  class << self
    def included(base)
      base.extend Classmethods
      base.send :include, InstanceMethods
    end
  end

  module Classmethods
    def validate(args)
      @validations ||= []
      @validations.push(args)
    end

    def type(hash, obj)
      raise "Wrong object type! Expected #{hash[:arg]}, but got #{obj.send(hash[:var]).class}" if obj.send(hash[:var]).class.to_s != hash[:arg].to_s && hash[:var].class.to_s != NilClass
    end

    def presence(hash, obj)
      raise "#{hash[:var]} not presented!" if obj.send(hash[:var]).nil? || obj.send(hash[:var]).to_s.empty?
    end

    def format(hash, obj)
      raise "#{obj.send(hash[:var])} in the wrong format!" if obj.send(hash[:var]) !~ hash[:arg]
    end

    def array_type(hash, obj)
      puts '+'
      obj.send(hash[:var]).each do |attribute|
        raise "Wrong object type! Expected #{hash[:arg]}, but got #{attribute.class}" if attribute.class.to_s != hash[:arg].to_s && attribute.class.to_s != NilClass
      end
    end
  end

  module InstanceMethods
    def validate!
      self.class.instance_variable_get('@validations').each do |hash|
        self.class.public_send(hash[:val].to_sym, hash, self)
      end
    end

    def valid?
      validate!
      true
    rescue RuntimeError => e
      puts e.inspect
      false
    end
  end
end
