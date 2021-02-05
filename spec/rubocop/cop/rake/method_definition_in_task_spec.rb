# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Rake::MethodDefinitionInTask, :config do
  it 'registers an offense to `def` in a task' do
    expect_offense(<<~RUBY)
      task :foo do
        def helper_method
        ^^^^^^^^^^^^^^^^^ Do not define a method in rake task, because it will be defined to the top level.
          do_something
        end
      end

      task :foo do
        do_something

        def helper_method
        ^^^^^^^^^^^^^^^^^ Do not define a method in rake task, because it will be defined to the top level.
          do_something
        end

        def self.foo
        ^^^^^^^^^^^^ Do not define a method in rake task, because it will be defined to the top level.
          do_something2
        end
      end
    RUBY
  end

  it 'registers an offense to `def` in a namespace' do
    expect_offense(<<~RUBY)
      namespace 'foo' do
        def helper_method
        ^^^^^^^^^^^^^^^^^ Do not define a method in rake task, because it will be defined to the top level.
          do_something
        end

        task :bar do
          helper_method
        end
      end
    RUBY
  end

  it 'does not register an offense to `def` at the top level' do
    expect_no_offenses(<<~RUBY)
      def foo
      end

      task :foo do
      end
    RUBY
  end

  it 'does not register an offense to `def` in a class or module' do
    expect_no_offenses(<<~RUBY)
      task :foo do
        Class.new do
          def initialize
            do_something
          end
        end

        Module.new do
          def foo
            do_something
          end
        end

        # C will be defined to the top level scope,
        # but it should be detected by another cop.
        class C
          def foo
            do_something
          end
        end

        module M
          def foo
            do_something
          end
        end
      end
    RUBY
  end
end
