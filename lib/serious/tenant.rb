module Serious
  module Tenant
    mattr_accessor :ekylibre_path

    class << self
      # Test if a tenant already exist
      def exist?(name)
        list.include?(name.to_s)
      end

      # Test if a tenant already exist
      def list
        l = execute_command('bin/rake tenant:list')
        l.strip.split(/[\s\,]+/)
      end

      # Drop tenant
      def drop(name)
        execute_command "bin/rake tenant:drop TENANT=#{name}"
      end

      # Create tenant
      def create(name)
        execute_command "bin/rake tenant:create TENANT=#{name}"
      end

      def execute_command(cmd)
        `cd #{ekylibre_path} && #{cmd}`
      end

      def create_instances(instances)
        existings = list

        instances.each do |name, _details|
          drop(name) if existings.include?(name)
          create(name)
        end
      end

      def write_nginx_snippet(instances, options = {})
        upstream = options[:upstream] || 'serious'
        name = 'serious_farms.conf'

        # /etc/nginx/snippets/<upstream>_instances.conf
        root = Rails.env.development? ? Rails.root.join('config', 'environments', 'development') : Pathname.new('/')
        file = options[:file] || root.join('etc', 'nginx', 'snippets', name)

        conf = "# Config for Serious Game\n"
        conf << "# Generated automatically.\n"
        conf << "# Include this file in your Ekylibre server\n"
        instances.each do |name, _details|
          conf << "location /#{name} {\n"
          # conf << "  error_page 404              /404.html;\n"
          # conf << "  error_page 422              /422.html;\n"
          # conf << "  error_page 500 502 503 504  /500.html;\n"
          # conf << "  error_page 403              /403.html;\n"
          conf << "  try_files $uri @#{name}_farm;\n"
          conf << "}\n\n"

          conf << "location @#{name}_farm {\n"
          conf << "  rewrite /#{name}/(.*)$ /$1 break;\n"
          conf << "  proxy_set_header Host            $http_host;\n"
          conf << "  proxy_set_header X-Real-IP       $remote_addr;\n"
          conf << "  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n"
          conf << "  proxy_set_header X-Tenant        #{name};\n"
          conf << "  proxy_redirect   off;\n"
          if Rails.env.development?
            conf << "  proxy_pass       http://localhost:3001;\n"
          else
            conf << "  proxy_pass       http://#{upstream}_farms;\n"
          end
          conf << "}\n\n"
        end

        File.write(file, conf)
      end
    end
  end
end
