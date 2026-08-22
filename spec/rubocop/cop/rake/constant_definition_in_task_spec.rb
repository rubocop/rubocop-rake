# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Rake::ConstantDefinitionInTask, :config do
  it 'registers an offense to a constant assignment in a task' do
    expect_offense(<<~RUBY)
      task :foo do
        CONST = 1
        ^^^^^^^^^ Do not assign a constant in rake task, because it will be defined to the top level.
      end
    RUBY
  end

  it 'registers an offense to a constant assignment in a namespace' do
    expect_offense(<<~RUBY)
      namespace :foo do
        CONST = 1
        ^^^^^^^^^ Do not assign a constant in rake task, because it will be defined to the top level.

        task :bar do
        end
      end
    RUBY
  end

  it 'does not register an offense to a constant assignment at the top level' do
    expect_no_offenses(<<~RUBY)
      CONST = 1

      task :foo do
      end
    RUBY
  end

  it 'does not register an offense to a constant assignment inside a class in a task' do
    expect_no_offenses(<<~RUBY)
      task :foo do
        Class.new do
          CONST = 1
        end
      end
    RUBY
  end
end
