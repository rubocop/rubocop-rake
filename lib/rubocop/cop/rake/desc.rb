# frozen_string_literal: true

module RuboCop
  module Cop
    module Rake
      # Rake task definition should have a description with `desc` method.
      # It is useful as a documentation of task. And Rake does not display
      # task that does not have `desc` by `rake -T`.
      #
      # @example
      #   # bad
      #   task :do_something
      #
      #   # bad
      #   task :do_something do
      #   end
      #
      #   # good
      #   desc 'Do something'
      #   task :do_something
      #
      #   # good
      #   desc 'Do something'
      #   task :do_something do
      #   end
      #
      class Desc < Cop
        MSG = 'Describe the task with `desc` method.'

        def_node_matcher :task?, <<~PATTERN
          (send nil? :task ...)
        PATTERN

        def on_send(node)
          return unless task?(node)
          return if task_with_desc?(node)

          add_offense(node)
        end

        private def task_with_desc?(node)
          parent, task = parent_and_task(node)
          return false unless parent

          idx = parent.children.find_index(task) - 1
          desc_candidate = parent.children[idx]
          return false unless desc_candidate

          desc_candidate.send_type? && desc_candidate.method_name == :desc
        end

        private def parent_and_task(task_node)
          parent = task_node.parent
          return nil, task_node unless parent
          return parent, task_node unless parent.block_type?

          # rubocop:disable Style/GuardClause
          if parent.children.find_index(task_node) == 0
            # when task {}
            return parent.parent, parent
          else
            # when something { task }
            return parent, task_node
          end
          # rubocop:enable Style/GuardClause
        end
      end
    end
  end
end
