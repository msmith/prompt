# Prompt

## What is this?

Prompt makes it easy to build slick command-line applications with Tab Completion, Command History, and Built-in Help

## Installation

    gem install prompt

## An example

Commands are defined with a Sinatra-inspired DSL:

```ruby
require 'prompt'
extend Prompt::DSL

group "Move"

param :direction, "A cardinal direction", %w(north east south west)

command "go :direction", "Walk in the specified direction" do |direction|
  puts "You walked #{direction} and were eaten by a grue."
end

group "Interact"

command "look", "Look around" do
  puts "You're in a dark room."
end

command "say :something", "Say something" do |something|
  puts "You say '#{something}'"
end

Prompt::Console.start
```

### Tab completion

Tab completion is hooked up automatically after you define your commands and parameters

    $ my_app
    > g<TAB>
    > go <TAB>
    east   north  south  west
    > go n<TAB>
    > go north

### Command history

Command history is enabled automatically.  You can scroll through the history with the UP and DOWN keys.  You can search the history with CTRL-R.

You can preserve the history between runs by specifying a history filename when starting the console

```ruby
history_file = File.join(ENV["HOME"], ".my-history")
Prompt::Console.start history_file
```


### Built-in help

The `help` command is built-in.  It will print all of the commands that you've defined in your app.

    $ my_app
    > help
    Console commands

      help                                     List all commands
      help -v                                  List all commands, including parameters
      exit                                     Exit the console

    Move

      go <direction>                           Walk in the specified direction

    Interact

      look                                     Look around
      say <something>                          Say something

## Grouping commands

You can put commands in logical groups.  This only affects how help is printed.

```ruby
group "File commands"

command ...
command ...

group "Directory commands"

command ...
```

## Using Parameters

Parameters can be used in a command:

```ruby
command "name :first :last" do |first, last|
  puts "Hi #{first} #{last}"
end
```

Here, the parameters are named `first` and `last`.  Their values are be passed as arguments to the command's block, in the order in which they appear.


Each `:parameter` only matches a single word.  If you want to match multiple words to one parameter, use a `*parameter`.

```ruby
command "cp *file :dest" do |files, dest|
  puts "You copied #{files.length} files to #{dest}"
end
```

### Defining parameters

It's not necessary to define a parameter before using it in a command, but doing so will allow you to provide a useful description and list of possible completions for the parameter.

```ruby
param :name, "Description"
```

### Specifying parameter completions

You can specify the completions for a parameter as a static list:

```ruby
param :color, "A color", %w(red green blue)
```

or as a dynamically-generated one:

```ruby
param :file, "JPG file" do
  Dir.glob "*.jpg"
end
```

A dynamic parameter's block may optionally take the partially-typed word as
a parameter, to further limit the completions.

```ruby
param :username do |starting_with|
  # slow DB query
  User.where("username LIKE '?%'", starting_with).map(&:username)
end
```

## Configuration options

The default prompt `"> "` can be changed before starting the console, or while it's running.

```ruby
Prompt.application.prompt = "#{Dir.pwd}> "
```
