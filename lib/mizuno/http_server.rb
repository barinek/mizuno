module Mizuno
  class HttpServer
    include_class 'org.eclipse.jetty.server.Server'
    include_class 'org.eclipse.jetty.servlet.ServletContextHandler'
    include_class 'org.eclipse.jetty.servlet.ServletHolder'
    include_class 'org.eclipse.jetty.util.thread.QueuedThreadPool'
    include_class 'org.eclipse.jetty.servlet.DefaultServlet'
    include_class 'org.eclipse.jetty.jmx.MBeanContainer'
    include_class 'org.eclipse.jetty.server.Server'

    include_class 'java.lang.management.ManagementFactory'
    include_class 'javax.management.MBeanServer'

    include_class 'org.slf4j.Logger'
    include_class 'org.slf4j.LoggerFactory'

    @@logger = LoggerFactory.getLogger("HttpServer")

    def self.run(app, options = {})
      options = Hash[options.map { |option| [option[0].to_s.downcase.to_sym, option[1]] }]

      port = options[:port].to_i

      thread_pool = QueuedThreadPool.new
      thread_pool.min_threads = 5
      thread_pool.max_threads = 50

      rack_handler = RackHandler.new
      rack_handler.rackup(app)

      @server = Server.new(port)
      @container = MBeanContainer.new(ManagementFactory.getPlatformMBeanServer)
      @server.container.addEventListener(@container)
      @server.set_thread_pool(thread_pool)
      @server.set_handler(rack_handler)
      @server.start

      @@logger.info("Started jetty on port {}.", port)

      trap("SIGINT") { @server.stop and exit }

      @server.join unless options[:embedded]
    end

    def self.stop
      @server.stop

      @@logger.info("Stopper jetty.")
    end
  end
end

Rack::Handler.register 'mizuno', 'Mizuno::HttpServer'
