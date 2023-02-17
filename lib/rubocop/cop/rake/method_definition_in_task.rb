# frozen_string_literal: true

module RuboCop
  module Cop
    module Rake
      # Detects method definition in a namespace,
      # because it is defined to the top level.
      # It is confusing because the scope looks in the namespace,
      # but actually it is defined to the top level.
      #
      # @example
      #   # good
      #   task :foo do
      #     def helper_method
      #       do_something
      #     end
      #   end
      #
      #   # bad
      #   namespace :foo do
      #     def helper_method
      #       do_something
      #     end
      #   end
      #
      #   # good - It is also defined to the top level,
      #   #        but it looks expected behavior.
      #   def helper_method
      #   end
      #   task :foo do
      #   end
      #
      class MethodDefinitionInTask < Base
        MSG = 'Do not define a method in a rake namespace, because it will be defined to the top level.'

        def on_def(node)
          return if Helper::ClassDefinition.in_class_definition?(node)
          return unless Helper::TaskDefinition.in_namespace?(node)

          add_offense(node)
        end

        alias on_defs on_def
      end
    end
  end
end
