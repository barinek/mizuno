Gem::Specification.new do |spec|
  spec.name = "mizuno"
  spec.version = "0.4.0"
  spec.required_rubygems_version = Gem::Requirement.new(">= 1.2") \
        if spec.respond_to?(:required_rubygems_version=)
  spec.authors = ["Don Werve"]
  spec.description = 'Jetty-powered running shoes for JRuby/Rack.'
  spec.summary = 'Rack handler for Jetty 7 on JRuby.  Features multithreading, event-driven I/O, and async support.'
  spec.email = 'don@madwombat.com'
  spec.executables = ["mizuno"]
  spec.files = %w( .gitignore
        README.markdown
        LICENSE
        mizuno.gemspec
        lib/java/bonecp-0.7.0.jar
        lib/java/commons-io-2.0.1.jar
        lib/java/guava-r07.jar
        lib/java/jetty-continuation-7.3.0.v20110203.jar
        lib/java/jetty-deploy-7.3.0.v20110203.jar
        lib/java/jetty-http-7.3.0.v20110203.jar
        lib/java/jetty-io-7.3.0.v20110203.jar
        lib/java/jetty-jmx-7.3.0.v20110203.jar
        lib/java/jetty-security-7.3.0.v20110203.jar
        lib/java/jetty-server-7.3.0.v20110203.jar
        lib/java/jetty-servlet-7.3.0.v20110203.jar
        lib/java/jetty-util-7.3.0.v20110203.jar
        lib/java/jetty-webapp-7.3.0.v20110203.jar
        lib/java/jetty-xml-7.3.0.v20110203.jar
        lib/java/logback-classic-0.9.28.jar
        lib/java/logback-core-0.9.28.jar
        lib/java/mysql-connector-java-5.1.9.jar
        lib/java/servlet-api-2.5.jar
        lib/java/slf4j-api-1.6.1.jar
        lib/java/logback.xml
        lib/mizuno/http_server.rb
        lib/mizuno/rack_handler.rb
        lib/mizuno.rb
        bin/mizuno )
  spec.homepage = 'http://github.com/matadon/mizuno'
  spec.has_rdoc = false
  spec.require_paths = ["lib"]
  spec.rubygems_version = '1.3.6'
  spec.add_dependency('rack', '>= 1.0.0')
end
