module Dribbble
  class Base
    include HTTParty

    base_uri 'api.dribbble.com'

    def initialize(attributes=nil)
      attributes ||= {}
      @created_at = attributes.delete('created_at')
      attributes.each do |(attr, val)|
        instance_variable_set("@#{attr}", val)
        instance_eval "def #{attr}() @#{attr} end"
      end
    end

    def get(*args, &block)
      self.class.get(*args, &block)
    end

    def created_at
      parse_time(@created_at)
    end

    def ==(other)
      other.equal?(self) || (other.instance_of?(self.class) && other.id == id)
    end

    # Delegates to ==
    def eql?(other)
      self == other
    end

    def self.paginated_list(results)
      Dribbble::PaginatedList.new(results)
    end

    def paginated_list(results)
      self.class.paginated_list(results)
    end

    protected

    def parse_time(time_string)
      Time.parse(time_string) if time_string
    end
  end
end
