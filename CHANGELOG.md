# Changelog

This is updated when a new version is pushed to http://rubygems.org

## 1.2.0 (Apr 21, 2012)

* DSL change: Command descriptions can be provided using `desc`.  You can still
  pass the description as an argument to `command`, but will be deprecated
  in a future version. (thanks @kowsik)
* Partially-typed strings are now passed when calling a parameter's block.  You
  can use this to more efficiently build the list of completions.  This is
  especially useful for things like database queries or other remote API calls.

## 1.1.0 (Apr 18, 2012)

* Format help command so that descriptions are always aligned
* Rescue and print exceptions

## 1.0.0 (Apr 10, 2012)

* Display suggestions when command is not found

## 0.2.0 (Mar 17, 2012)

* Exit immediately on Ctrl-C
* Tab completing a `*param` will now include the completions for the following word
  if the `*param` has already been matched at least once
* [BUG] Use the cached parameter values, when available

## 0.1.0 (Mar 8, 2012)

* DSL change: `desc` was renamed to `group`
* Tab completion will now list only the completions for the current word, instead of
  the whole command.  This makes it behave like bash and works much better with `*params`
* Hitting ENTER with an empty line will no longer print a Command Not Found error

## 0.0.3 (Feb 22, 2012)

* DSL change: `variable` & `dynamic_variable` were renamed to `param`
* A glob parameter (e.g. `*param`) will now return its matches as an array of strings
* Quoted strings will now work as expected with glob parameters
* Dynamic variables are cached until the next command is run
* Added LICENSE.txt

## 0.0.2 (Feb 17, 2012)

* Allow the command prompt to be changed while it's running
* Quoted strings will now match to a single `:param`
* Use a `*param` to match one or more words
* [BUG] Don't memoize Command#regex.  This prevented dynamic variables
  from working correctly after the values changed

## 0.0.1 (Feb 16, 2012)

* Initial release
