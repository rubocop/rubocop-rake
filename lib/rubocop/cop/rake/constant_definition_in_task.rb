# frozen_string_literal: true

module RuboCop
  module Cop
    module Rake
      # Detects constant assignment in a task or namespace,
      # because it is defined to the top level.
      # It is confusing because the scope looks in the task or namespace,
      # but actually it is defined to the top level.
      #
      # Class and module definitions are covered by `Rake/ClassDefinitionInTask`.
      #
      # @example
      #   # bad
      #   task :foo do
      #     CONST = 1
      #   end
      #
      #   # bad
      #   namespace :foo do
      #     CONST = 1
      #   end
      #
      #   # good - It is also defined to the top level,
      #   #        but it looks expected behavior.
      #   CONST = 1
      #   task :foo do
      #   end
      #
      class ConstantDefinitionInTask < Base
        MSG = 'Do not assign a constant in rake task, because it will be defined to the top level.'

        def on_casgn(node)
          return if Helper::ClassDefinition.in_class_definition?(node)
          return unless Helper::TaskDefinition.in_task_or_namespace?(node)

          add_offense(node)
        end
      end
    end
  end
end
