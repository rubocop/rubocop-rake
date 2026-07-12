# frozen_string_literal: true

RSpec.describe 'RuboCop Rake project' do # rubocop:disable RSpec/DescribeClass
  describe 'department cop registration' do
    it 'registers every cop file in `lib/rubocop/cop/rake` exactly once' do
      cop_root = File.expand_path('../lib/rubocop/cop', __dir__)
      files = Dir[File.join(cop_root, 'rake', '*.rb')].sort
      files -= [File.join(cop_root, 'rake', 'helper.rb')]

      registered = RuboCop::Cop::Registry.global.cops_for_department(:Rake).map do |cop|
        Object.const_source_location(cop.name).first
      end.sort

      expect(registered).to eq(files)
    end
  end
end
