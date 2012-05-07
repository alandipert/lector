require 'citrus'
require 'lector/types'

module Lector
  ['digits', 'reader'].each do |grammar|
    Citrus.load(File.join(File.dirname(__FILE__), 'lector', grammar), :force => true)
  end
end

module Lector
  module RubyParse; end
  module Digits; end
  def self.read_s(string, opts = {})
    $_LECTOR_READ_EVAL = opts[:read_eval] || false
    string_without_comments = $_LECTOR_READ_EVAL ? string : string.gsub(/#[^=].*$/, '')
    Lector::RubyParse::parse(string_without_comments).val
  end
  def self.read_file(file, opts = {})
    read_s(File.read(file), opts)
  end
end
