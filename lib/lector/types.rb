module Lector
  module Types
    module Data; def val; form.val; end; end
    module Boolean; def val; to_s == "true"; end; end
    module Nil; def val; nil; end; end
    module Integer; def val; to_i; end; end
    module HexInteger; def val; to_i 16; end; end
    module Float; def val; to_f; end; end
    module SimpleSymbol; def val; slice(1..-1).to_sym; end; end
    module StringSymbol; def val; slice(2..-2).to_sym; end; end
    module HashKey; def val; to_sym; end; end
    module String; def val; captures[:content].first.gsub(/\\\"/,"\""); end; end

    module Array
      def val
        captures[:form].map(&:val)
      end
    end

    module Hash
      def val
        ruby_val = {}
        captures[:form].each_slice(2) do |slice|
          key,value = slice
          ruby_val[key.val] = value.val
        end
        ruby_val
      end
    end
  end
end
