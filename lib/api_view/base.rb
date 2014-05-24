
module ApiView

  class Base

    class << self

      def for_model(model)
        ApiView.add_model(model, self)
      end

      def attributes(*attrs)

        @attributes ||= []
        @attributes = (@attributes + attrs).flatten.sort.uniq

        # create a method which reads each attribute from the model object and
        # copies it into the hash, then returns the hash itself
        code = ["def collect()", "super"]
        @attributes.each do |a|
          code << "@hash[:#{a}] = @object.send(:#{a})"
        end
        code << "@hash"
        code << "end"
        class_eval(code.join("\n"))

      end
      alias_method :attrs, :attributes

    end

    attr_reader :object, :hash
    alias_method :obj, :object

    def initialize(object)
      @object = object
      @hash = {}
    end

    def collect
      @hash # no-op by default
    end

    def convert
      collect()
    end

    def attrs(obj, *attrs)
      return {} if attrs.empty?
      if attrs.size == 1 and attrs.first == :all then
        return obj.serializable_hash
      end

      ret = {}
      attrs.each do |a|
        ret[a] = obj.send(a)
      end
      return ret
    end

    def attrs_except(obj, *attrs)
      return obj.serializable_hash({ :except => attrs })
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
