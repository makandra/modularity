gem 'activesupport'
require 'active_support/all'
require 'fileutils'

module Modularity
  class Migrator
    class << self

      def migrate(old_path)
        old_path = File.expand_path(old_path)
        new_path = fix_filename(old_path)
        rename(old_path, new_path) unless old_path == new_path
        old_code = File.read(new_path)
        new_code = fix_code(old_code)
        rewrite_file(new_path, new_code) unless old_code == new_code
        puts "Migrated #{old_path}"
        `ruby -c #{new_path}`
        new_code
      end

      private

      def fix_filename(path)
        path = File.expand_path(path)
        new_path = path.sub(/\/([^\/]+)_trait\.rb$/, '/does_\\1.rb')
        new_path
      end

      def fix_code(code)
        code = code.gsub(/module (.*?)([A-Za-z0-9_]+)Trait\b/, 'module \\1Does\\2')
        code = code.gsub(/does ['":]([A-Za-z0-9\_\/]+)(?:'|"|$)(?:,\s*(.*)$)?/) do
          trait_path = $1
          parameters = $2
          trait_path = trait_path.sub(/([A-Za-z0-9\_]+)$/, 'does_\\1')
          trait_class = trait_path.camelize # don't use classify, it removes plurals!
          substituted = "include #{trait_class}"
          substituted << "[#{parameters}]" if parameters
          substituted
        end
        code
      end

      def rename(old, new)
        FileUtils.mv(old, new)
      end

      def rewrite_file(path, content)
        File.open(path, "w") { |file| file.write(content) }
      end

    end
  end
end
