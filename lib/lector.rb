require 'citrus'
require 'lector/types'

module Lector
  Citrus.load('lib/lector/digits', :force => true)
  Citrus.load('lib/lector/reader', :force => true)
end

module Lector
  module RubyParse; end
  def self.read_s(string, opts = {})
    $_LECTOR_READ_EVAL = opts[:read_eval] || false
    string_without_comments = $_LECTOR_READ_EVAL ? string : string.gsub(/#[^=].*$/, '')
    Lector::RubyParse::parse(string_without_comments).val
  end
  def self.read_file(file, opts = {})
    read_s(File.read(file), opts)
  end
end
