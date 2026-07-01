# frozen_string_literal: true

require_relative 'rake/helper'

module RuboCop
  module Cop
    # Cops for the `Rake` department. The department's cops are
    # registered for lazy loading and their files are loaded on demand.
    module Rake
      extend LazyLoader

      register_cop :ClassDefinitionInTask, "#{__dir__}/rake/class_definition_in_task"
      register_cop :Desc, "#{__dir__}/rake/desc"
      register_cop :DuplicateTask, "#{__dir__}/rake/duplicate_task"
      register_cop :DuplicateNamespace, "#{__dir__}/rake/duplicate_namespace"
      register_cop :MethodDefinitionInTask, "#{__dir__}/rake/method_definition_in_task"
      register_cop :RequireOutsideTask, "#{__dir__}/rake/require_outside_task"
    end
  end
end
