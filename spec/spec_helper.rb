$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'yaml'
require 'net/http'
require 'rack/urlmap'
require 'rack/lint'
require 'mizuno'

Thread.abort_on_exception = true
