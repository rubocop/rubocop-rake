# frozen_string_literal: true

require 'rubocop'

require_relative 'rubocop/rake'
require_relative 'rubocop/rake/version'
require_relative 'rubocop/rake/inject'

RuboCop::Rake::Inject.defaults!

require_relative 'lib/rubocop/cop/rake_cops.rb'
