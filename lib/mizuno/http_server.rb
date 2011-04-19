module Mizuno
  class HttpServer
    include_class 'org.eclipse.jetty.server.Server'
    include_class 'org.eclipse.jetty.servlet.ServletContextHandler'
    include_class 'org.eclipse.jetty.servlet.ServletHolder'
    include_class 'org.eclipse.jetty.server.nio.SelectChannelConnector'
    include_class 'org.eclipse.jetty.util.thread.QueuedThreadPool'
    include_class 'org.eclipse.jetty.servlet.DefaultServlet'

    include_class 'org.eclipse.jetty.jmx.MBeanContainer'
    include_class 'org.eclipse.jetty.server.Server'
    include_class 'javax.management.MBeanServer'
    include_class 'java.lang.management.ManagementFactory'

    include_class 'com.mysql.jdbc.Driver'

    include_class 'org.slf4j.Logger'
    include_class 'org.slf4j.LoggerFactory'
    include_class 'org.slf4j.impl.StaticLoggerBinder'

    @@logger = LoggerFactory.getLogger("HttpServer")

    def self.run(app, options = {})
      options = Hash[options.map { |option| [option[0].to_s.downcase.to_sym, option[1]] }]

      thread_pool = QueuedThreadPool.new
      thread_pool.min_threads = 5
      thread_pool.max_threads = 50

      connector = SelectChannelConnector.new
      connector.setPort(options[:port].to_i)
      connector.setHost(options[:host])

      rack_handler = RackHandler.new
      rack_handler.rackup(app)

      @server = Server.new
      @container = MBeanContainer.new(ManagementFactory.getPlatformMBeanServer)
      @server.container.addEventListener(@container)
      @server.set_thread_pool(thread_pool)
      @server.addConnector(connector)
      @server.set_handler(rack_handler)
      @server.start

      @@logger.info("Started jetty on #{connector.getHost}:#{connector.getPort}")

      trap("SIGINT") { @server.stop and exit }

      @server.join unless options[:embedded]
    end

    def self.stop
      @server.stop
      @container.stop

      @@logger.info("Stopper jetty.")
    end
  end
end

Rack::Handler.register 'mizuno', 'Mizuno::HttpServer'
