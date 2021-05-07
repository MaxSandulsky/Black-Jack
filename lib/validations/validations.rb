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

    def type_validation(attribute, type, obj)
      raise "Wrong object type! Expected #{type}, but got #{obj.send(attribute).class.to_s}" if obj.send(attribute).class.to_s != type && attribute.class.to_s != NilClass
    end
    
    def presence_validation(attribute, obj)
      raise "#{attribute} not presented!" if obj.send(attribute).nil? || obj.send(attribute).to_s.empty?
    end
    
    def format_validation(attribute, format, obj)
      raise "#{obj.send(attribute)} in the wrong format!" if obj.send(attribute) !~ format
    end
    
    def array_type_var_validation(array, type, obj)
      obj.send(array).each do |attribute|
        raise "Wrong object type! Expected #{type}, but got #{attribute.class.to_s}" if attribute.class.to_s != type && attribute.class.to_s != NilClass
      end
    end
  end

  module InstanceMethods
    def validate!
      self.class.instance_variable_get('@validations').each do |hash|
        self.class.type_validation(hash[:var], hash[:arg].to_s, self) if hash[:val] == 'type'
        self.class.presence_validation(hash[:var], self) if hash[:val] == 'presence'
        self.class.format_validation(hash[:var], hash[:arg], self) if hash[:val] == 'format'
        self.class.array_type_var_validation(hash[:var], hash[:arg].to_s, self) if hash[:val] == 'array_type'
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