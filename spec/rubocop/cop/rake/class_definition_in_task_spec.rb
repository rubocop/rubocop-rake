# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Rake::ClassDefinitionInTask do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense to a class definition in task' do
    expect_offense(<<~RUBY)
      task :foo do
        class C
        ^^^^^^^ Do not define a class in rake task, because it will be defined to the top level.
        end
      end
    RUBY
  end

  it 'registers an offense to a module definition in task' do
    expect_offense(<<~RUBY)
      task :foo do
        module M
        ^^^^^^^^ Do not define a module in rake task, because it will be defined to the top level.
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

  it 'allows class definition outside task' do
    expect_no_offenses(<<~RUBY)
      class C
      end

      task :foo do
      end
    RUBY
  end
end
