# frozen_string_literal: true

RSpec.describe 'cop lazy loading' do # rubocop:disable RSpec/DescribeClass
  def run_script(source)
    Dir.mktmpdir do |dir|
      script = File.join(dir, 'script.rb')
      File.write(script, source)
      lib = File.expand_path('../lib', __dir__)
      output = `#{RbConfig.ruby} -I #{lib} #{script} 2>&1`
      raise "script failed:\n#{output}" unless $CHILD_STATUS.success?

      output
    end
  end

  it 'registers all cops without loading their files' do
    output = run_script(<<~RUBY)
      require 'rubocop-rake'

      registry = RuboCop::Cop::Registry.global
      loaded = $LOADED_FEATURES.grep(%r{/rubocop/cop/rake/(?!helper)})

      puts "registered=\#{registry.names.grep(%r{\\ARake/}).size}"
      puts "loaded_cop_files=\#{loaded.size}"
    RUBY

    expect(output).to include('registered=5', 'loaded_cop_files=0')
  end

  it 'resolves every helper file in `lib/rubocop/cop/rake/helper` through an autoload' do
    helper_root = File.expand_path('../lib/rubocop/cop/rake/helper', __dir__)

    output = run_script(<<~RUBY)
      require 'rubocop-rake'

      resolved = Dir[File.join('#{helper_root}', '*.rb')].sort.all? do |file|
        name = File.basename(file, '.rb').split('_').map(&:capitalize).join
        RuboCop::Cop::Rake::Helper.const_get(name)
        Object.const_source_location("RuboCop::Cop::Rake::Helper::\#{name}").first == file
      end

      puts "resolved=\#{resolved}"
    RUBY

    expect(output).to include('resolved=true')
  end

  it 'loads helpers on demand rather than at require time' do
    output = run_script(<<~RUBY)
      require 'rubocop-rake'

      loaded = $LOADED_FEATURES.grep(%r{/rubocop/cop/rake/helper/})

      puts "loaded_helper_files=\#{loaded.size}"
    RUBY

    expect(output).to include('loaded_helper_files=0')
  end

  it 'does not register a cop twice when its file is required directly' do
    output = run_script(<<~RUBY)
      require 'rubocop-rake'

      before = RuboCop::Cop::Registry.global.length
      require 'rubocop/cop/rake/desc'
      after = RuboCop::Cop::Registry.global.length

      puts "stable=\#{before == after}"
      puts "class=\#{RuboCop::Cop::Registry.global.find_by_cop_name('Rake/Desc')}"
    RUBY

    expect(output).to include('stable=true', 'class=RuboCop::Cop::Rake::Desc')
  end
end
