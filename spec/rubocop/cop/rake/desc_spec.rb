# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Rake::Desc do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'register an offense for task on the top level' do
    expect_offense(<<~RUBY)
      task :foo
      ^^^^^^^^^ Describe the task with `desc` method.

      task :foo do
      ^^^^^^^^^ Describe the task with `desc` method.
        bar
      end
    RUBY
  end

  it 'register an offense for task with block in a block' do
    expect_offense(<<~RUBY)
      tap do
        task :foo
        ^^^^^^^^^ Describe the task with `desc` method.
      end

      tap do
        something 'foo'
        task :foo do
        ^^^^^^^^^ Describe the task with `desc` method.
          bar
        end
      end
    RUBY
  end

  it 'does not register an offense for task with desc' do
    expect_no_offenses(<<~RUBY)
      desc 'Do foo'
      task :foo do
      end

      desc 'Do bar'
      task :bar
    RUBY
  end
end
