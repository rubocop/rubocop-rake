# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Rake::Desc, :config do
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

  it 'register an offense for task in kwbegin' do
    expect_offense(<<~RUBY)
      begin
        task :foo
        ^^^^^^^^^ Describe the task with `desc` method.
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

  it 'does not register an offense for the default task' do
    expect_no_offenses(<<~RUBY)
      task default: :spec

      task default: [:spec, :rubocop]
    RUBY
  end

  it 'does not register an offense when `task` is not a definition' do
    expect_no_offenses(<<~RUBY)
      task.name
    RUBY
  end

  it 'registers an offense for one prerequisite declaration (alias)' do
    expect_offense(<<~RUBY)
      task release: 'changelog:check_clean'
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Describe the task with `desc` method.
    RUBY
  end

  it 'does not register an offense for multiple prerequisite declarations' do
    expect_no_offenses(<<~RUBY)
      task release: ['changelog:check_clean', 'changelog:create']
    RUBY
  end
end
