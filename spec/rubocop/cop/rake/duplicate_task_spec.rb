# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Rake::DuplicateTask do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense when `foo` is duplicated' do
    expect_offense(<<~RUBY, 'test.rb')
      task :foo do
      end

      task :foo do
      ^^^^^^^^^ Task `foo` is defined at both test.rb:1 and test.rb:4.
      end
    RUBY
  end

  it 'registers an offense when `:foo` and `"foo"`' do
    expect_offense(<<~RUBY, 'test.rb')
      task :foo do
      end

      task "foo" do
      ^^^^^^^^^^ Task `foo` is defined at both test.rb:1 and test.rb:4.
      end
    RUBY
  end

  it 'registers an offense with a namespace' do
    expect_offense(<<~RUBY, 'test.rb')
      namespace :foo do
        task 'bar' do
        end
      end

      task 'foo:bar' do
      ^^^^^^^^^^^^^^ Task `foo:bar` is defined at both test.rb:2 and test.rb:6.
      end
    RUBY
  end

  it 'registers an offense with a name with Hash' do
    expect_offense(<<~RUBY, 'test.rb')
      task foo: :bar do
      end

      task :foo do
      ^^^^^^^^^ Task `foo` is defined at both test.rb:1 and test.rb:4.
      end
    RUBY
  end

  it 'does not register an offense with no duplicated tasks' do
    expect_no_offenses(<<~RUBY)
      task :foo do
      end

      task :bar do
      end
    RUBY
  end

  it 'does not register an offense with the same name for task and namespace' do
    expect_no_offenses(<<~RUBY)
      task :foo do
      end

      namespace :foo do
      end
    RUBY
  end

  it 'does not register an offense with the same name but in the different namespace' do
    expect_no_offenses(<<~RUBY)
      task :foo do
      end

      namespace :bar do
        task :foo do
        end
      end
    RUBY
  end

  it 'ignores task name or namespace are undecidable' do
    expect_no_offenses(<<~RUBY)
      task foo do
      end

      namespace bar do
        task :foo do
        end
      end
    RUBY
  end
end
