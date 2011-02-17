module P2Ruby
  # Represents external Driver for P2 Router server app
  class Router
    ROUTER_TITLE = Regexp.new('P2MQRouter - ')
    include P2Ruby

    def initialize opts = {}
      @ini_file = Pathname(opts[:ini] || opts[:ini_file] || "./client_router.ini")
      error "Wrong ini file name" unless @ini_file.expand_path.exist? || opts[:args]

      title = opts[:title] || ROUTER_TITLE
      dir = opts[:dir]
      path = opts[:path] || opts[:dir] && opts[:dir] + 'P2MQRouter.exe'
      args = opts[:args] || "/ini:#{@ini_file}"
      timeout = opts[:timeout] || 3

#      begin
        @app = WinGui::App.launch(:dir => dir, :path => path, :args => args,
                                  :title => title, :timeout => timeout)
#      rescue => e
#        error e
#      end
    end

  end # class Router
end # module P2Ruby

