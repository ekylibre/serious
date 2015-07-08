module Serious
  module Tenant

    mattr_accessor :ekylibre_path

    class << self

      # Test if a tenant already exist
      def exist?(name)
        execute_command "bin/rake tenant:exist TENANT=#{name}"
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

    end

  end
end
