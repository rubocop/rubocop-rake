# frozen_string_literal: true

module RuboCop
  module Cop
    module Rake
      # This cop detects method definition in a task or namespace,
      # because it is defined to the top level.
      # It is confusing because the scope looks in the task or namespace,
      # but actually it is defined to the top level.
      #
      # @example
      #   # bad
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
      class MethodDefinitionInTask < Cop
        MSG = 'Do not define a method in rake task, because it will be defined to the top level.'

        def_node_matcher :bad_method?, <<~PATTERN
          (send nil? :bad_method ...)
        PATTERN

        def_node_matcher :class_definition?, <<~PATTERN
          {
            class module sclass
            (block
              (send (const {nil? cbase} {:Class :Module}) :new)
              args
              _
            )
          }
        PATTERN

        def_node_matcher :task_or_namespace?, <<-PATTERN
          (block
            (send _ {:task :namespace} ...)
            args
            _
          )
        PATTERN

        def on_def(node)
          return if in_class_definition?(node)
          return unless in_task_or_namespace?(node)

          add_offense(node)
        end

        alias on_defs on_def

        private def in_class_definition?(node)
          node.each_ancestor(:class, :module, :sclass, :block).any? do |a|
            class_definition?(a)
          end
        end

        private def in_task_or_namespace?(node)
          node.each_ancestor(:block).any? do |a|
            task_or_namespace?(a)
          end
        end
      end
    end
  end
end
