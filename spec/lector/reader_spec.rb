require File.join(File.dirname(__FILE__), *%w[.. spec_helper.rb])
require 'pry'
require 'tempfile'

describe Lector do
  context 'reading strings' do
    it 'parses integers' do
      Lector::read_s("+42").should == 42
      Lector::read_s("-42").should == -42
      Lector::read_s("42").should == 42
      Lector::read_s("-42").should == -42
      Lector::read_s("-0").should == 0
      Lector::read_s("+0").should == 0
    end

    it "parses hex integers" do
      Lector::read_s("0x0").should == 0
      Lector::read_s("0xF").should == 15
      Lector::read_s("+0xF").should == 15
      Lector::read_s("-0xF").should == -15
    end

    it "parses ocatals" do
      Lector.read_s("00").should == 0
      Lector.read_s("010").should == 8
      Lector.read_s("-010").should == -8
      Lector.read_s("+010").should == 8
    end

    it "parses floating point numbers" do
      Lector::read_s("1.1").should == 1.1
      Lector::read_s("-1.1").should == -1.1
      Lector::read_s("-1.21e10").should == -12_100_000_000.0
      Lector::read_s("+1.21e10").should == 12_100_000_000.0
      Lector::read_s("1e4").should == 10_000
      expect { Lector::read_s("1.") }.to raise_error(Citrus::ParseError)
      expect { Lector::read_s("1.e5") }.to raise_error(Citrus::ParseError)
    end

    context "parsing individual underscores in the middle of numbers" do
      it "in integers" do
        Lector::read_s("1_0").should == 10
        Lector::read_s("1_03_4").should == 1034
        expect { Lector::read_s("1_03_4_") }.to raise_error(Citrus::ParseError)
        expect { Lector::read_s("1__03_4") }.to raise_error(Citrus::ParseError)
      end

      it "in octals" do
        Lector::read_s("0_1_0").should == 010
        Lector::read_s("0_1_03_4").should == 01034
        expect { Lector::read_s("0_1_03_4_") }.to raise_error(Citrus::ParseError)
        expect { Lector::read_s("0_1__03_4") }.to raise_error(Citrus::ParseError)
      end

      it "in hex" do
        Lector::read_s("0x3_f_0").should == 0x3F0
        Lector::read_s("0x1_0D_4").should == 0x10D4
        expect { Lector::read_s("0x1_03_4_") }.to raise_error(Citrus::ParseError)
        expect { Lector::read_s("0x_1_03_4") }.to raise_error(Citrus::ParseError)
        expect { Lector::read_s("0x1__03_4") }.to raise_error(Citrus::ParseError)
      end

      it "in floats" do
        Lector.read_s("1_0.2_3").should == 10.23
        Lector.read_s("1_0.2_3e4_5").should == 10.23e45
        expect { Lector.read_s("1__0.2") }.to raise_error(Citrus::ParseError)
        expect { Lector.read_s("_1_0.2") }.to raise_error(Citrus::ParseError)
        expect { Lector.read_s("1._2") }.to raise_error(Citrus::ParseError)
        expect { Lector.read_s("1.1__2") }.to raise_error(Citrus::ParseError)
        expect { Lector.read_s("1.2_") }.to raise_error(Citrus::ParseError)
        expect { Lector.read_s("1.2e1__3") }.to raise_error(Citrus::ParseError)
        expect { Lector.read_s("1.2e_3") }.to raise_error(Citrus::ParseError)
        expect { Lector.read_s("1.2e3_") }.to raise_error(Citrus::ParseError)
      end
    end

    it "parses true and false" do
      Lector::read_s("true").should == true
      Lector::read_s("false").should == false
    end

    it "parses nil" do
      Lector::read_s("nil").should == nil
    end

    it 'parses symbols' do
      Lector::read_s(":sym").should == :sym
      Lector::read_s(':"blah"').should == :blah
      Lector::read_s(':"blah blah"').should == :"blah blah"
      Lector::read_s(":'foo foo'").should == :"foo foo"
    end

    it 'parses arrays of single elements' do
      Lector::read_s('[42]').should == [42]
    end

    it 'ignores whitespace' do
      Lector::read_s("[ 42   ]").should == [42]
    end

    it 'parses arrays of multiple elements' do
      Lector::read_s("[42, -1]").should == [42, -1]
    end

    it 'fails to parse arrays with spurious commas' do
      expect { Lector::read_s('[1,,2]') }.to raise_error(Citrus::ParseError)
    end

    it 'allows trailing commas in arrays' do
      Lector::read_s('[1,2,]').should == [1,2]
    end

    it 'parses hashes' do
      Lector::read_s("{a: 7, b: 6}").should == {:a => 7, :b => 6}
      Lector::read_s("{b: 6}").should == {:b => 6}
      Lector::read_s("{:a => 7, :b => 6}").should == {:a => 7, :b => 6}
      Lector::read_s("{:a => 7, b: 6}").should == {:a => 7, :b => 6}
    end

    it 'parses nested collections' do
      Lector::read_s("[[1,2], 3, 4]").should == [[1, 2], 3, 4]
    end

    it 'has no problem with hashes of arrays' do
      Lector::read_s("{a: [1, 2], b: [3, 4]}").should == {:a => [1, 2], :b => [3, 4]}
      Lector::read_s("{:a => [1, 2], :b => [3, 4]}").should == {:a => [1, 2], :b => [3, 4]}
    end

    it 'copes when data is surrounded by whitespace' do
      Lector::read_s("
{a: 7, b: 6}   ").should == {:a => 7, :b => 6}
    end

    it 'reads double-quoted strings' do
      Lector::read_s('"a string by any other name is just as tangly"').should == 'a string by any other name is just as tangly'
    end

    it 'reads single-quoted strings' do
      Lector::read_s("'i only have single quotes'").should == 'i only have single quotes'
    end

    it 'reads strings with escaped quotes' do
      Lector::read_s('"a string with an \"escaped quote\""').should == 'a string with an "escaped quote"'
    end

    it 'preserves other escaped characters' do
      Lector::read_s('"a string with a\nnewline"').should == 'a string with a\nnewline'
    end

    it 'deals with comments' do
      Lector::read_s("{#Here's a comment in the code.\nx: #And another!\n10}").
        should == {:x => 10}
    end
  end

  context 'read-evaling' do
    it "blows up when read-eval is off and there's embedded code" do
      expect {
        Lector::read_s("#='1+2'").should == '1+2'
      }.to raise_error(RuntimeError)
    end

    it "embedded code works when :read_eval is on" do
      Lector::read_s("#='1+2'", :read_eval => true).should == 3
    end

    it "copes when strings have comments" do
      Lector::read_s("[:a#some comment\n,:b,:c]").should == [:a, :b, :c]
    end
  end

  context 'reading files' do
    it 'should be able to round-trip data to file' do
      hsh = {:a => [1, 2], nil => false, :b => [3, 4], blah: [1.2, {:x => 20}]}
      Tempfile.new('lector').tap do |f|
        f.write(hsh.to_s)
        f.rewind
        Lector::read_file(f).should == hsh
      end
    end
  end
end
