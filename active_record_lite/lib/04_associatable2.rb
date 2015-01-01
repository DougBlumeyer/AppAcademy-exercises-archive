require_relative '03_associatable'

# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      p through_options
      p through_options.table_name
      p through_options.model_class
      p source_options
      p source_options.table_name
      p source_options.model_class

      results = DBConnection.execute(<<-SQL)
        -- SELECT
        --   *
        -- FROM
        --   #{source_options.table_name}
        -- JOIN
        --   #{through_options.table_name}
        -- ON #{source_options.table_name}.#{source_options.primary_key} =
        --    #{through_options.table_name}.#{through_options.foreign_key}
        -- WHERE
        -- --#{source_options.table_name}.#{source_options.primary_key} =
        -- #{through_options.table_name}.#{through_options.foreign_key} =
        --   #{send(through_options.foreign_key)}


        SELECT
          #{source_options.table_name}.*
        FROM
          #{source_options.table_name}
        JOIN
          #{through_options.table_name}
        ON
        #{through_options.table_name}.#{source_options.foreign_key} =
        #{source_options.table_name}.#{through_options.primary_key}
        WHERE
        #{through_options.table_name}.#{through_options.primary_key} =
        #{send(through_options.primary_key)}
      SQL

      source_options.model_class.parse_all(results).first
    end
  end
end
