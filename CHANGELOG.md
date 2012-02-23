# Changelog

This is updated when a new version is pushed to http://rubygems.org

## 0.0.3 (Feb 22, 2011)

* DSL change: `variable` & `dynamic_variable` were renamed to `param`
* A glob parameter (e.g. `*param`) will now return its matches as an array of strings
* Quoted strings will now work as expected with glob parameters
* Dynamic variables are cached until the next command is run
* Added LICENSE.txt

## 0.0.2 (Feb 17, 2011)

* Allow the command prompt to be changed while it's running
* Quoted strings will now match to a single `:param`
* Use a `*param` to match one or more words
* [BUG] Don't memoize Command#regex.  This prevented dynamic variables
  from working correctly after the values changed

## 0.0.1 (Feb 16, 2011)

* Initial release
