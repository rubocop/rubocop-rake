# frozen_string_literal: true

module RuboCop
  module Cop
    module Rake
      module Helper
        module TaskDefinition
          extend NodePattern::Macros
          extend self

          def_node_matcher :namespace?, <<-PATTERN
            (block
              (send _ {:namespace} ...)
              args
              _
            )
          PATTERN

          def_node_matcher :task?, <<-PATTERN
            (block
              (send _ {:task} ...)
              args
              _
            )
          PATTERN

          def in_namespace?(node)
            node.each_ancestor(:block).any? do |a|
              namespace?(a)
            end
          end

          def in_task?(node)
            node.each_ancestor(:block).any? do |a|
              task?(a)
            end
          end
        end
      end
    end
  end
end
