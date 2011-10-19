require 'rubygems'
require 'minitest/autorun'
require 'fileutils'
require 'arel'
require 'support/fake_record'

require 'bundler/setup'
require 'ruby-debug'
require 'arc'
Arel::Table.engine = Arc::DataStores[:sqlite].new(:database => "tmp/arc.sqlite3", :adapter => :sqlite)

def load_schema
  file = 'tmp/arc.sqlite3'
  File.delete(file) if File.exists? file
  ddl = File.read('test/support/schema.sql')
  puts ddl
  Arel::Table.engine.schema.execute_ddl ddl  
end

class Object
  def must_be_like other
    gsub(/\s+/, ' ').strip.must_equal other.gsub(/\s+/, ' ').strip
  end
end

load_schema