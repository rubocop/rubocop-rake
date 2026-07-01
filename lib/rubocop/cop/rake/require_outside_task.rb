# frozen_string_literal: true

module RuboCop
  module Cop
    module Rake
      # Detects `require` and `require_relative` calls that are not inside a
      # task block.
      #
      # A rake file's top level - including the body of a `namespace` block -
      # is evaluated every time the file is loaded. A require placed there
      # therefore runs on every rake invocation, instead of only when the task
      # that needs it runs. Move the require inside the task (or a
      # `Rake::Task#enhance` block) so the dependency is loaded lazily.
      #
      # @example
      #   # bad
      #   require 'foo'
      #
      #   task :foo do
      #     Foo.do_something
      #   end
      #
      #   # bad - the namespace body is still evaluated on load
      #   namespace :foo do
      #     require 'foo'
      #
      #     task :bar do
      #       Foo.do_something
      #     end
      #   end
      #
      #   # good
      #   task :foo do
      #     require 'foo'
      #     Foo.do_something
      #   end
      #
      #   # good
      #   Rake::Task['db:seed'].enhance do
      #     require 'foo'
      #     Foo.do_something
      #   end
      #
      class RequireOutsideTask < Base
        MSG = 'Do not `require` outside of a task block, because it is loaded every time the rake file is loaded.'
        RESTRICT_ON_SEND = %i[require require_relative].freeze

        # @!method task_block?(node)
        def_node_matcher :task_block?, <<~PATTERN
          (block (send nil? :task ...) ...)
        PATTERN

        # @!method task_enhance_block?(node)
        def_node_matcher :task_enhance_block?, <<~PATTERN
          (block
            (send
              (send (const (const nil? :Rake) :Task) :[] ...)
              :enhance ...)
            ...)
        PATTERN

        def on_send(node)
          return if inside_task_block?(node)

          add_offense(node)
        end

        private def inside_task_block?(node)
          node.each_ancestor(:block).any? do |ancestor|
            task_block?(ancestor) || task_enhance_block?(ancestor)
          end
        end
      end
    end
  end
end
