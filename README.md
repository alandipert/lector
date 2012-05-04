`lector` reads Ruby data as a string or from a file without evaluating the code it reads. [![Build Status](https://secure.travis-ci.org/alandipert/lector.png)](http://travis-ci.org/alandipert/lector)

# Usage

```
> require 'lector'
 => true
> Lector::read_s("{x: 11, :pants? => false}")
 => {:x=>11, :pants?=>false} 
```

Please see the
[tests](https://github.com/alandipert/lector/tree/master/spec/lector)
for more usage examples.

# Rationale

Ruby's literal support for hashes, arrays, keywords, numbers, and
strings makes Ruby data slightly more expressive than JSON and
arguably as expressive as YAML.

Ruby could be a decent format for representing things like markup or
configuration data.  This library allows you to digest Ruby data
strings and files without having to worry if arbitrary code will
execute.

# Thanks

This library started as a fork of Michael Fogus and Alex Redington's
[clj.rb](https://github.com/fogus/clj.rb), a library for parsing
[Clojure](http://clojure.org) data from Ruby.  A big thanks to them
for getting this party started.