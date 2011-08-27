class FakeDataStore
  class Column < Struct.new(:name, :type)
  end

  attr_reader :tables, :columns_hash, :executed

  def initialize visitor_name=:sqlite3
    @tables = %w{ users photos developers products}
    @columns = {
      'users' => [
        Column.new('id', :integer),
        Column.new('name', :string),
        Column.new('bool', :boolean),
        Column.new('created_at', :date)
      ],
      'products' => [
        Column.new('id', :integer),
        Column.new('price', :decimal)
      ]
    }
    @columns_hash = {
      'users' => Hash[@columns['users'].map { |x| [x.name, x] }],
      'products' => Hash[@columns['products'].map { |x| [x.name, x] }]
    }
    @primary_keys = {
      'users' => 'id',
      'products' => 'id'
    }
    @visitor_name = visitor_name
    @executed = []
  end
  
  def config
    {:adapter => @visitor_name}
  end
  
  def visitor
    Arel::Visitors.for self
  end
  
  def primary_key name
    @primary_keys[name.to_s]
  end

  def table_exists? name
    @tables.include? name.to_s
  end

  def columns name, message = nil
    @columns[name.to_s]
  end

  def quote_table_name name
    "\"#{name.to_s}\""
  end

  def quote_column_name name
    "\"#{name.to_s}\""
  end

  def quote thing, column = nil
    if column && column.type == :integer
      return 'NULL' if thing.nil?
      return thing.to_i
    end
    
    case thing
    when true
      "'t'"
    when false
      "'f'"
    when nil
      'NULL'
    when Numeric
      thing
    else
      "'#{thing}'"
    end
  end

  def execute sql, name = nil, *args
    @executed << sql
  end
  alias :update :execute
  alias :delete :execute
  alias :insert :execute
end
