# frozen_string_literal: true

module RuboCop
  module Cop
    module Rake
      # Autoloads helper modules included by cops. Helpers are autoloaded to
      # reduce the number of requires because they're used only when
      # the relevant cop class is loaded.
      module Helper
        autoload :ClassDefinition, "#{__dir__}/helper/class_definition"
        autoload :OnNamespace, "#{__dir__}/helper/on_namespace"
        autoload :OnTask, "#{__dir__}/helper/on_task"
        autoload :TaskDefinition, "#{__dir__}/helper/task_definition"
        autoload :TaskName, "#{__dir__}/helper/task_name"
      end
    end
  end
end
