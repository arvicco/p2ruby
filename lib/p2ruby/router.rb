module P2
  # Represents external Driver for P2 Router server app
  class Router
    ROUTER_TITLE = Regexp.new('P2MQRouter - ')
    include P2

    def self.find
      router = ::WinGui::App.find :title => ROUTER_TITLE
      router ? new(:app => router) : nil
    end

    attr_reader :opts, :app

    def initialize opts = {}
      @opts = opts.dup
      if @opts[:app]
        @app = @opts[:app]
      else
        @opts[:ini] = Pathname(@opts[:ini] || @opts[:ini_file] || "./client_router.ini")
        error "Wrong ini file name" unless @opts[:ini].expand_path.exist? || @opts[:args]

        @opts[:title] ||= ROUTER_TITLE
        @opts[:path] ||= @opts[:dir] && @opts[:dir] + 'P2MQRouter.exe'
        @opts[:args] ||= "/ini:#{@opts[:ini]}"
        @opts[:timeout] ||= 3

        @app = ::WinGui::App.launch(:dir => @opts[:dir],
                                    :path => @opts[:path],
                                    :args => @opts[:args],
                                    :title => @opts[:title],
                                    :timeout => @opts[:timeout])
      end
    end

    def method_missing *args
      @app.send *args
    end

    def title
      @app.main_window.title
    end

  end # class Router
end # module P2

