# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Rake::ClassDefinitionInNamespace, :config do
  it 'allows class definition in task' do
    expect_no_offenses(<<~RUBY)
      task :foo do
        class C
        end
      end
    RUBY
  end

  it 'allows module definition in task' do
    expect_no_offenses(<<~RUBY)
      task :foo do
        module M
        end
      end
    RUBY
  end

  it 'registers an offense to a class definition in namespace' do
    expect_offense(<<~RUBY)
      namespace 'foo' do
        class C
        ^^^^^^^ Do not define a class in a rake namespace, because it will be defined to the top level.
        end
      end
    RUBY
  end

  it 'registers an offense to a module definition in namespace' do
    expect_offense(<<~RUBY)
      namespace 'foo' do
        module M
        ^^^^^^^^ Do not define a module in a rake namespace, because it will be defined to the top level.
        end
      end
    RUBY
  end

  it 'allows class definition in Class.new' do
    expect_no_offenses(<<~RUBY)
      task :foo do
        Class.new do
          class C
          end
        end
      end
    RUBY
  end

  it 'allows class definition at the top level' do
    expect_no_offenses(<<~RUBY)
      class C
      end

      task :foo do
      end
    RUBY
  end
end
