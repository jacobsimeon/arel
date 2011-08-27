require 'rubygems'
require 'minitest/autorun'
require 'fileutils'
require 'arel'

require 'support/fake_data_store'
Arel::Table.engine = FakeDataStore.new

class Object
  def must_be_like other
    gsub(/\s+/, ' ').strip.must_equal other.gsub(/\s+/, ' ').strip
  end
end
