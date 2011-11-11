# This file contains EventedDataStream class and its helper modules/classes

module Mix

  # Provides #try method that nicely wraps WIN32OLE exception handling in host classes
  module ExceptionWrapper
    # Exception handling wrapper for Win32OLE exceptions.
    # Catch/log Win32OLE exceptions, pass on all others...
    def try
      yield
    rescue WIN32OLERuntimeError => e
      puts :error, "Ignoring caught Win32ole runtime error:", e
      sleep 0.1 # Give other Threads a chance to execute
    rescue Exception => e
      self.finalize if respond_to? :finalize
      puts :error, "Raising non-Win32ole error:", e
      raise e
    end
  end
end
