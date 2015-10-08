module Serious
  module Slave
    class << self
      def url_for(path)
        master_url + path
      end

      def master_url
        @master_url ||= config[:master_url]
      end

      def config
        @config ||= YAML.load_file(Rails.root.join('config', 'slave.yml')).deep_symbolize_keys[Rails.env.to_sym] || {}
      end

      def path
        @path ||= (config[:path] =~ /^\//) ? Pathname.new(config[:path]) : Rails.root.join(config[:path])
      end

      def domain
        config[:domain]
      end

      def rake(task, env = {})
        env['RAILS_ENV'] = config[:env] || Rails.env
        vars = env.collect{|k,v| "#{k}=#{Shellwords.escape(v)}" }.join(' ')
        exec("bin/rake #{task} #{vars}")
      end

      def exec(command)
        Dir.chdir(path) do
          puts command.blue
          `#{command}`
        end
      end
    end
  end
end
