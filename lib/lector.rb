require 'citrus'
require 'lector/types'

module Lector
  Citrus.load('lib/lector/reader', :force => true)
end

module Lector
  module RubyParse; end
  def self.read_s(string)
    Lector::RubyParse::parse(string).val
  end
  def self.read_file(file)
    Lector::RubyParse::parse(File.read(file)).val
  end
end
