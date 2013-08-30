require "anti_offensive_string/version"
require 'rack'
require 'stringio'

class AntiOffensiveString
  class InsecureRequest < Exception; end

  TARGET_REGEXPS = [
    /\u0647\u0020\u0488\u0488\u0488|%D9%87[ +]%D2%88%D2%88%D2%88/
  ].freeze
  TARGET_REGEXPS.each(&:freeze)

  DEFAULT_HANDLER = proc { [400, {'Content-Type' => 'text/plain'}, ['400 Bad Request']] }

  class << self
    def on_offensive_request(&block)
      @handler = block
    end

    def handler=(proc_or_obj)
      @handler = if proc_or_obj.kind_of?(Proc)
                   proc_or_obj
                 else
                   proc { proc_or_obj }
                 end
    end

    alias error_response= handler=

    def handler
      @handler ||= DEFAULT_HANDLER
    end
  end

  def initialize(app)
    @app = app
  end

  def call(env)
    input = env['rack.input'].read
    if TARGET_REGEXPS.any? { |r| r === input }
      raise InsecureRequest
    end

    env.each do |k, v|
      if v.kind_of?(String) && TARGET_REGEXPS.any? { |r| r === v }
        raise InsecureRequest
      end
    end

    begin
      env['rack.input'].rewind
    rescue Errno::ESPIPE
      env['rack.input'] = StringIO.new(input, "r")
    end

    @app.call(env)
  rescue InsecureRequest
    return self.class.handler.call(env)
  end
end
