
module ApiView

  class Base < ::Hash

    class << self

      def for_model(model)
        ApiView.add_model(model, self)
      end

      def attributes(*attrs)

        @attributes ||= []
        @attributes = (@attributes + attrs).flatten.sort.uniq

        # create a method which reads each attribute from the model object and
        # copies it into the hash, then returns the hash itself
        # e.g.,
        # def collect_attributes
        #   super
        #   self[:foo] = @object.send(:foo)
        #   ...
        #   self
        # end
        code = ["def collect_attributes()", "super"]
        @attributes.each do |a|
          code << "self.store :#{a}, @object.send(:#{a})"
        end
        # code << "self"
        code << "end"
        class_eval(code.join("\n"))

      end
      alias_method :attrs, :attributes

    end

    attr_reader :object
    alias_method :obj, :object

    def initialize(object)
      super(nil)
      @object = object
    end

    def collect_attributes
      # self # no-op by default
    end

    def convert
      collect_attributes()
    end

    def render(obj, options)
      Engine.convert(obj, options)
    end

  end

  class Default < Base
    def self.convert(obj)
      if obj.respond_to? :to_api then
        obj.to_api
      elsif obj.respond_to? :to_hash then
        obj.to_hash
      elsif obj.respond_to? :serializable_hash then
        obj.serializable_hash
      else
        obj
      end
    end
  end # Default

end
