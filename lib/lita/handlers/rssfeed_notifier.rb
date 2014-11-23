require 'rss'
require 'yaml'

module Lita
  module Handlers
    class RssfeedNotifier < Handler
      on :connected, :start
      on :loaded, :start
      on :disconnected, :stop
      on :shut_down_started, :stop

      route(/start\s+watching/, :start)
      route(/stop\s+watching/, :stop)

      def start(response)
        return if (redis.get(:state) == 'polling')
        redis.set(:state, 'polling')
        every(5) do |timer|
          begin
            item = unread_items.first
            if item
              response.reply(message(item))
              save_as_last(item)
            else
              response.reply("no item") if ENV['DEBUG']
            end
            timer.stop if (redis.get(:state) == 'idle')
          rescue ConfigFileReadError
            response.reply("A config read error occurred :(")
            timer.stop
          rescue ConfigPlaceHolderError
            response.reply("Invalid message template detected, please fix :(")
            timer.stop
          rescue ConfigRSSCallError
            response.reply("Invalid reference to RSS object in config file, please fix :(")
            timer.stop
          rescue
            response.reply("orz : Unknown error occured")
            timer.stop
          end
        end
      end

      def stop(response = nil)
        redis.set(:state, 'idle')
      end

      private
      LASTFILE = './lasttime.txt'

      def unread_items
        load
        @rss.items.select { |item|
          item.date > @last
        }.reverse
      end

      def load
        @rss ||= RSS::Parser.parse(rss_config['feed_url'], false)
        if File.exists?(LASTFILE)
          @last = Time.parse(File.read(LASTFILE))
        else
          @last = Time.new(0)
        end
      end

      def save_as_last(item)
        File.open(LASTFILE, "w") { |f|
          f.write(item.date.to_time.to_s)
        }
      end

      MESSAGE_CONFIG = './message_config.yml'
      def rss_config
        unless @conf
          confs = YAML.load(File.read(MESSAGE_CONFIG))
          @conf = confs[confs.keys.first] # @ToDo multi site
        end
        @conf
      rescue
        raise ConfigFileReadError
      end

      def message(rss)
        templates = rss_config['messages']

        begin
          str = templates[rand(templates.size)].dup
          rss_config['replaces'].keys.each do |key|
            values = rss_config['replaces'][key]
            str.gsub!("[[#{key}]]", values[rand(values.size)])
          end
        rescue
          raise ConfigPlaceHolderError
        end

        begin
          rss_placeholders = str.scan(/\[\[rss#([^\]]+)\]\]/).map { |m| m[0] }
          rss_placeholders.each do |attr|
            str.gsub!("[[rss##{attr}]]", rss.__send__(attr.to_sym))
          end
        rescue
          raise ConfigRSSCallError
        end
        str
      end

      class ConfigPlaceHolderError < StandardError; end
      class ConfigFileReadError < StandardError; end
      class ConfigRSSCallError < StandardError; end
    end

    Lita.register_handler(RssfeedNotifier)
  end
end
