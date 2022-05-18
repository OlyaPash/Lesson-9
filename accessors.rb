module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      var_name_hist = []

      define_method(name) { instance_variable_get(var_name) }

      define_method("#{name}=".to_sym) do |value|
        instance_variable_set(var_name, value)
        var_name_hist << value
      end
      define_method("@#{name}_history".to_sym) { var_name_hist }
    end
  end

  def strong_attr_accessor(name, class_name)
    var_name = "@#{name}".to_sym
    define_method(name) { instance_variable_get(var_name) }
    define_method("#{name}=".to_sym) do |value|
      raise TypeError "Тип значения не совпадает" if self.class != class_name

      instance_variable_set(var_name, value)
    end
  end
end
