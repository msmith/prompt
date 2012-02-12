# Prompt

## What is this?

Prompt makes it easy to build slick command-line applications with [Tab Completion](#tabcompletion), [Command History](#commandhistory), and [Built-in Help](#built-inhelp)

## Installation

    gem install prompt

## An example

Commands are defined with a Sinatra-inspired DSL:

```ruby
require 'prompt'
extend Prompt::DSL

desc "Move"

variable :direction, "A cardinal direction", %w(north east south west)

command "go :direction", "Walk in the specified direction" do |direction|
  puts "You walked #{direction} and were eaten by a grue."
end

desc "Interact"

command "look", "Look around" do
  puts "You're in a dark room."
end

command "say :something", "Say something" do |something|
  puts "You say '#{something}'"
end

Prompt::Console.start
```

### Tab completion

Tab completion is hooked up automatically after you define your commands and variables

    $ my_app
    > g<TAB>
    > go <TAB>
    go east   go north  go south  go west
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

      help -v
      help
      exit

    Move

      go <direction>                           Walk in the specified direction

    Interact

      look                                     Look around
      say <something>                          Say something

## Grouping commands

You can put commands in logical groups.  This only affects how help is printed.

```ruby
desc "Taco commands"

command ...
command ...

desc "Burger commands"

command ...
```

## Using Variables

Variables can be used in a command.

```ruby
command "name :first :last" do |first, last|
  puts "Hi #{first} #{last}"
end
```

Here, the variables are named `first` and `last`.  Their values are be passed as arguments to the command's block, in the order in which they appear.

### Defining variables

It's not necessary to define a variable before using it in a command, but doing so will allow you to provide a useful description and valid values for the variable.

```ruby
variable :name, "Description"
```

### Specifying a static list of valid values

You can specify a static list of valid values for a variable.  These will be expanded when using tab completion.

```ruby
variable :name, "Description", %w(value1 value2)
```

### Specifying a dynamic list of valid values

Instead of specifying a static list, you can specify a block that will dynamically return a list of valid values for a variable.  These will be expanded when using tab completion.  

```ruby
dynamic_variable :file, "JPG file" do
  Dir.glob "*.jpg"
end
```

## Configuration options

The default prompt `"> "` can be changed before starting the console, or while it's running.

```ruby
Prompt::Console.prompt = "#{Dir.pwd}> "
```
