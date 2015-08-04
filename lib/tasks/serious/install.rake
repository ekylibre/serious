namespace :serious do
  namespace :install do
    desc 'Install in dev mode'
    task :development do
      fail 'Must run as root' unless Process.uid == 0
    end

    desc 'Install base file for production installation'
    task :production do
      fail 'Must run as root' unless Process.uid == 0
      game_name  = ENV['GAME_NAME'] || 'game'
      farms_name = ENV['FARMS_NAME'] || 'farms'
      app_name = 'serious'
      domain   = ENV['DOMAIN'] || "#{app_name}.lan"

      ssl = false
      ssl = true if Rails.env.production?

      game_domain = "#{game_name}.#{domain}"
      # /etc/nginx/site-availables/serious.conf
      conf  = "# Config for Serious Game\n\n"

      conf << "upstream #{app_name}_#{game_name} {\n"
      conf << "  server unix:/var/run/#{app_name}/#{game_name}/web.socket fail_timeout=0;\n"
      conf << "}\n\n"

      # HTTP
      conf << "# Configuration serious game platform\n"
      conf << "server #{game_domain} {\n"
      conf << "  listen      #{game_domain}:80;\n"
      conf << "  server_name #{game_domain};\n"
      conf << "  return 301 https://#{game_domain}$request_uri;\n"
      conf << "}\n\n"

      # HTTPS
      conf << "server #{game_domain} {\n"
      conf << "  listen      #{game_domain}:443 ssl;\n"
      conf << "  server_name #{game_domain};\n\n"

      conf << "  client_max_body_size 10M;\n\n"

      conf << "  ssl_certificate     /etc/ssl/certs/#{game_domain}.pem;\n"
      conf << "  ssl_certificate_key /etc/ssl/private/#{game_domain}.key;\n"
      conf << "  ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;\n"
      conf << "  ssl_session_cache   shared:SSL:10m;\n\n"

      conf << "  root /var/www/#{app_name}/#{game_name}/current/public;\n\n"

      conf << "  location / {\n"
      conf << "    try_files $uri @ruby;\n"
      conf << "  }\n"

      conf << "  location @ruby {\n"
      conf << "    # proxy_set_header X-Forwarded-Proto https; # unquote if you are in HTTPs\n"
      conf << "    proxy_set_header Host $http_host;\n"
      conf << "    proxy_redirect off;\n"
      conf << "    proxy_read_timeout 1200;\n"
      conf << "    proxy_pass http://#{app_name}_#{game_name};\n"
      conf << "  }\n"

      conf << "  location ~ \"^/([0-5]{3}.html|system|images|assets|favicon.ico|robots.txt)\"  {\n"
      conf << "    gzip_static   on;\n"
      conf << "    expires       max;\n"
      conf << "    add_header    Cache-Control public;\n"
      conf << "    break;\n"
      conf << "  }\n\n"

      conf << "}\n\n"

      farms_domain = "#{farms_name}.#{domain}"

      conf << "upstream #{app_name}_#{farms_name} {\n"
      conf << "  server unix:/var/run/#{app_name}/#{farms_name}/web.socket fail_timeout=0;\n"
      conf << "}\n\n"

      conf << "# Configuration for farms of serious game\n"
      conf << "server #{farms_domain} {\n"
      conf << "  listen      #{farms_domain}:80;\n"
      conf << "  server_name #{farms_domain};\n"
      conf << "  return 301 https://#{farms_domain}$request_uri;\n"
      conf << "}\n\n"

      conf << "server #{farms_domain} {\n"
      conf << "  listen      #{farms_domain}:443 ssl;\n"
      conf << "  server_name #{farms_domain};\n\n"

      conf << "  client_max_body_size 10M;\n\n"

      conf << "  ssl_certificate     /etc/ssl/certs/#{farms_domain}.pem;\n"
      conf << "  ssl_certificate_key /etc/ssl/private/#{farms_domain}.key;\n"
      conf << "  ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;\n"
      conf << "  ssl_session_cache   shared:SSL:10m;\n\n"

      conf << "  root /var/www/#{app_name}/#{farms_name}/current/public;\n"

      conf << "  location ~ \"^/\w+/([0-5]{3}.html|system|images|assets|favicon.ico|robots.txt)\"  {\n"
      conf << "    gzip_static   on;\n"
      conf << "    expires       max;\n"
      conf << "    add_header    Cache-Control public;\n"
      conf << "    break;\n"
      conf << "  }\n\n"

      conf << "  # Include farms conf updated by serious\n"
      conf << "  include /etc/nginx/snippets/#{app_name}_farms.conf\n\n"

      conf << "}\n\n"
    end
  end
end
