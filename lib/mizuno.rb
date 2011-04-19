require 'java'

$CLASSPATH << File.join(File.dirname(__FILE__), 'java', '/')

jars = File.join(File.dirname(__FILE__), 'java', '*.jar')

Dir[jars].each { |jar_file| require jar_file }

require 'rack'
require 'mizuno/rack_handler'
require 'mizuno/http_server'