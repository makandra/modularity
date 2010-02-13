# These methods are backported from Rails so modularity works with plain Ruby.

module Modularity
  class Inflector
    class << self

      # File activesupport/lib/active_support/inflector.rb, line 160
      def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
        if first_letter_in_uppercase
          lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
        else
          lower_case_and_underscored_word.first + camelize(lower_case_and_underscored_word)[1..-1]
        end
      end

      # File activesupport/lib/active_support/inflector.rb, line 278
      def constantize(camel_cased_word)
        unless /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/ =~ camel_cased_word
          raise NameError, "#{camel_cased_word.inspect} is not a valid constant name!"
        end

        Object.module_eval("::#{$1}", __FILE__, __LINE__)
      end

    end
  end
end
