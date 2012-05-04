require 'citrus'
require 'lector/types'

module Lector
  Citrus.load('lib/lector/reader', :force => true)
end

module Lector
  module RubyParse
    def self.read_s(string)
      parse(string).val
    end
    def self.read_file(file)
      parse(File.read(file)).val
    end
  end
end
