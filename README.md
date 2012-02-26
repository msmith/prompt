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

      help                                     List all commands
      help -v                                  List all commands, including parameters
      exit

    Move

      go <direction>                           Walk in the specified direction

    Interact

      look                                     Look around
      say <something>                          Say something

## Grouping commands

You can put commands in logical groups.  This only affects how help is printed.

```ruby
group "Taco commands"

command ...
command ...

group "Burger commands"

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
command "say *word" do |words|
  puts "You said #{words.length} words"
end
```

### Defining parameters

It's not necessary to define a parameter before using it in a command, but doing so will allow you to provide a useful description and list of possible completions for the parameter.

```ruby
param :name, "Description"
```

### Specifying a static list of completions

You can specify a static list of values for a parameter.  These will be used during tab completion.

```ruby
param :name, "Description", %w(value1 value2)
```

### Specifying a dynamic list of completions

You can also return the list of completions dynamically, by using a block.

```ruby
param :file, "JPG file" do
  Dir.glob "*.jpg"
end
```

## Configuration options

The default prompt `"> "` can be changed before starting the console, or while it's running.

```ruby
Prompt.application.prompt = "#{Dir.pwd}> "
```
