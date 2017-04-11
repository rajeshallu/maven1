class Versioned
  @@after_initialize = []
  attr_accessor :version
  attr_accessor :title

  def initialize
    @@after_initialize.each do |block|
      self.instance_eval(&block)
    end
  end

  def new_record?
    true
  end

  def self.table_name
    "versioneds"
  end

  def self.has_and_belongs_to_many(name, options = {})
    define_method(name) do
      instance_variable_get("@#{name}") || []
    end

    define_method("#{name}=") do |value|
      instance_variable_set("@#{name}", value)
    end
  end

  def self.after_initialize(&block)
    @@after_initialize << block
  end

  include Versionito
end
