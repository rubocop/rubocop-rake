# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Rake::DuplicateNamespace do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense when namespace `foo` is duplicated' do
    expect_offense(<<~RUBY, 'test.rb')
      namespace :foo do
      end

      namespace :foo do
      ^^^^^^^^^^^^^^ Namespace `foo` is defined at both test.rb:1 and test.rb:4.
      end
    RUBY
  end

  it 'registers an offense when namespace `:foo` and `"foo"`' do
    expect_offense(<<~RUBY, 'test.rb')
      namespace :foo do
      end

      namespace 'foo' do
      ^^^^^^^^^^^^^^^ Namespace `foo` is defined at both test.rb:1 and test.rb:4.
      end
    RUBY
  end

  it 'registers an offense with a nested namespace' do
    expect_offense(<<~RUBY, 'test.rb')
      namespace :foo do
        namespace 'bar' do
        end
      end

      namespace 'foo:bar' do
      ^^^^^^^^^^^^^^^^^^^ Namespace `foo:bar` is defined at both test.rb:2 and test.rb:6.
      end
    RUBY
  end

  it 'does not register an offense with no duplicated namespaces' do
    expect_no_offenses(<<~RUBY)
      namespace :foo do
      end

      namespace :bar do
      end
    RUBY
  end

  it 'does not register an offense with the same name for namespace and task' do
    expect_no_offenses(<<~RUBY)
      namespace :foo do
      end

      task :foo do
      end
    RUBY
  end

  it 'does not register an offense with the same name but in the different namespace' do
    expect_no_offenses(<<~RUBY)
      namespace :foo do
      end

      namespace :bar do
        namespace :foo do
        end
      end
    RUBY
  end
end
