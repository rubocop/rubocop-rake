# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Rake::RequireOutsideTask, :config do
  it 'registers an offense for `require` at the top level' do
    expect_offense(<<~RUBY)
      require 'foo'
      ^^^^^^^^^^^^^ Do not `require` outside of a task block, because it is loaded every time the rake file is loaded.

      task :foo do
        Foo.do_something
      end
    RUBY
  end

  it 'registers an offense for `require_relative` at the top level' do
    expect_offense(<<~RUBY)
      require_relative 'foo'
      ^^^^^^^^^^^^^^^^^^^^^^ Do not `require` outside of a task block, because it is loaded every time the rake file is loaded.

      task :foo do
      end
    RUBY
  end

  it 'registers an offense for `require` inside a namespace but outside a task' do
    expect_offense(<<~RUBY)
      namespace :foo do
        require 'foo'
        ^^^^^^^^^^^^^ Do not `require` outside of a task block, because it is loaded every time the rake file is loaded.

        task :bar do
          Foo.do_something
        end
      end
    RUBY
  end

  it 'does not register an offense for `require` inside a task' do
    expect_no_offenses(<<~RUBY)
      task :foo do
        require 'foo'
        Foo.do_something
      end
    RUBY
  end

  it 'does not register an offense for `require` inside a `Rake::Task#enhance` block' do
    expect_no_offenses(<<~RUBY)
      Rake::Task['db:seed'].enhance do
        require 'foo'
        Foo.do_something
      end
    RUBY
  end
end
