$:.unshift Dir.pwd

require 'rubygems'

require 'bundler'
Bundler.require

$:.unshift File.join(Dir.pwd, 'lib')
require 'toolbox'
