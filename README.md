# lita-rssfeed-notifier

Lita Handler plugin to do polling a RSS Feed.

## Installation

Add lita-rssfeed-notifier to your Lita instance's Gemfile:

``` ruby
gem "lita-rssfeed-notifier", github: 'komazarari/lita-rssfeed-notifier'
```


## Configuration
TODO: More details

Create `./message_config.yml` to configure robot's message.

``` yaml
site:
  feed_url: 'http://site-url/to-subscribe/rss10.xml'

  messages:
    - "Find update [[rss#title]] ! Let's go: [[rss#link]]"
    - "Oh [[rss#title]], [[mycomments]] [[myemos]] : [[rss#link]]"

  replaces:
    mycomments: ['yeah', 'cool', 'uhmm..']
    myemos:
      - ':('
      - ':)'
      - ':p'
```

Robot will post one of `messages` randomly with replacing placeholder `[[...]]`.

- `[[rss#<element>]]` will replaced with RSS element.
- `[[other_strings]]` will replaced with collections under `replaces` randomly.

## Usage

Create './message_config.yml' like above, and
```
Lita > start watching
```

## License

[MIT](http://opensource.org/licenses/MIT)
