# Redmanga

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/redmanga`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install redmanga

## Usage

Current support two commands `search` and `info`

`redmanga search`, which aslo can be used as `redmanga`, is used to search a managa and read it

`redmanga info` is used to search a managa and show some info about the manga
 
Please run `redmanga help` or `redmanga -h` for clearer usage guide

```
Usage: redmanga [opts] [commands]

opts:
    -h, --help                       Display this help.
    -V, --version                    Display current version.
    -v, --[no-]verbose               Show extra information.
    -g, --genres genre               Filter Manga's genres.
    -G, --excludes-genres genre      Exclude Manga's genres.
        --tags tag                   Filter Manga's tags.
    -c, --country country            Filter Manga's country.
    -f, --from year                  Only show Mangas from this year.
    -t, --to year                    Only show Mangas to this year.
    -T, --time days                  Only show Mangas in given days forward.
    -C, --completed                  Only show Mangas in given days forward.

commands:
    search:
        The command show list of mangas with the input name and open the selected it
        `redmanga search {name}`
        Replace {name} with the name you want to searched.
        If no command was input, this command will be default
    info:
        The command show list of mangas with the input name and show its info
        `redmanga info {name}`
        Replace {name} with the name you want to searched.
    version:
        Show version
    help:
        Show help menu
```

## Development

Run `bundle exec build` to build and install the dependencies of the script

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/redmanga. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/redmanga/blob/main/CODE_OF_CONDUCT.md).

## Credit

This Cli can be exist because of the [Comickfun's api](https://api.comick.fun/docs/static/index.html)

Please check out their main website [Comickfun](https://comick.fun/)

## Code of Conduct

Everyone interacting in the Redmanga project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/redmanga/blob/main/CODE_OF_CONDUCT.md).
