module PagSeguro
  module Extensions
    module MassAssignment
      def initialize(options = {})
        before_initialize if respond_to?(:before_initialize, true)
        options.each {|name, value| send("#{name}=", value) }
        after_initialize if respond_to?(:after_initialize, true)
      end
    end
  end
end
