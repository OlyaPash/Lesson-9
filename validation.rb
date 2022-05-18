module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_reader :validations

    def validate(attr_name, valid_type, *params)
      @validations ||= []
      @validations << { attr_name: attr_name, valid_type: valid_type, params: params }
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |validation|
        value = instance_variable_get("@#{validation[:attr_name]}")
        validation_method = "validate_#{validation[:valid_type]}"
        param = validation[:params]
        send(validation_method, value, *param)
      end
    end

    def validate_presence(value)
      raise "Значение не может быть пустым!" if value.nil? || value.empty?
    end

    def validate_format(value, format)
      raise "Значение не соответствует заданному формату!" if value !~ format
    end

    def validate_type(value, type)
      raise "Значение не соответствует классу!" if value.instance_of?(type)
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end
  end
end
