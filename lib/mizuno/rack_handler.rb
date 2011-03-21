module Mizuno
  include_class 'org.eclipse.jetty.server.handler.AbstractHandler'

  class RackHandler < AbstractHandler
    include_class 'java.io.FileInputStream'
    include_class 'org.apache.commons.io.IOUtils'

    def rackup(app)
      @app = app
    end

    def handle(target, baseRequest, request, response)
      env = rack_env_from(request)
      env['rack.java.servlet'] = true
      env['rack.java.servlet.request'] = request
      env['rack.java.servlet.response'] = response
      populate_servlet_response(@app.call(env), response)
      baseRequest.setHandled(true)
    end

    def rack_env_from(request)
      env = Hash.new
      env['REQUEST_METHOD'] = request.getMethod
      env['QUERY_STRING'] = request.getQueryString.to_s
      env['SERVER_NAME'] = request.getServerName
      env['SERVER_PORT'] = request.getServerPort.to_s
      env['rack.version'] = Rack::VERSION
      env['rack.url_scheme'] = request.getScheme
      env['HTTP_VERSION'] = request.getProtocol
      env["SERVER_PROTOCOL"] = request.getProtocol
      env['REMOTE_ADDR'] = request.getRemoteAddr
      env['REMOTE_HOST'] = request.getRemoteHost
      env['REQUEST_PATH'] = request.getRequestURI
      env['PATH_INFO'] = request.getRequestURI
      env['SCRIPT_NAME'] = ""

      env['REQUEST_URI'] = request.getRequestURL.toString
      env['REQUEST_URI'] << "?#{env['QUERY_STRING']}" if env['QUERY_STRING']

      env['rack.multiprocess'] = false
      env['rack.multithread'] = true
      env['rack.run_once'] = false

      request.getHeaderNames.each do |header_name|
        header = header_name.upcase.tr('-', '_')
        env["HTTP_#{header}"] = request.getHeader(header_name)
      end

      env["CONTENT_TYPE"] = env.delete("HTTP_CONTENT_TYPE") if env["HTTP_CONTENT_TYPE"]
      env["CONTENT_LENGTH"] = env.delete("HTTP_CONTENT_LENGTH") if env["HTTP_CONTENT_LENGTH"]
      env['rack.input'] = request.getInputStream.to_io
      env['rack.errors'] ||= $stderr
      env
    end

    def populate_servlet_response(rack_response, response)
      status, headers, body = rack_response

      content_length = headers.delete('Content-Length')

      response.setStatus(status)
      response.setContentLength(content_length.to_i) if content_length
      headers.each { |h, v| response.addHeader(h, v) }

      output = response.getOutputStream

      if (body.respond_to?(:to_path))
        file = File.new(body.to_path)
        response.setContentLength(file.length) unless content_length
        input = FileInputStream.new(file)
        IOUtils.write(input, output)
        IOUtils.closeSilently(input)
      else
        body.each { |l| IOUtils.write(l.to_java_bytes, output) }
      end

      body.close if body.respond_to?(:close)
      output.flush
      output.close
    end
  end
end

