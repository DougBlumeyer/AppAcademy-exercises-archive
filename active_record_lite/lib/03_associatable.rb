require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key,
  )

  def model_class
    self.class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    self.foreign_key = "#{name}_id".to_sym
    self.primary_key = "id".to_sym
    self.class_name = name.to_s.camelcase

    options.each do |attr_name, overriddance|
      send("#{attr_name}=".to_sym, overriddance)
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    self.foreign_key = "#{self_class_name.downcase}_id".to_sym
    self.primary_key = "id".to_sym
    self.class_name = name.to_s.camelcase.singularize

    options.each do |attr_name, overriddance|
      send("#{attr_name}=".to_sym, overriddance)
    end
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    self.assoc_options[name] = options
    define_method(name) do
      return nil if send(options.foreign_key).nil?
      results = DBConnection.execute(<<-SQL)
        SELECT
          *
        FROM
          #{options.table_name}
        WHERE
          #{options.primary_key} = #{send(options.foreign_key)}
      SQL

      options.model_class.parse_all(results).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)

    define_method(name) do
      results = DBConnection.execute(<<-SQL)
        SELECT
          *
        FROM
          #{options.table_name}
        WHERE
          #{options.foreign_key} = #{send(options.primary_key)}
      SQL

      options.model_class.parse_all(results)
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
