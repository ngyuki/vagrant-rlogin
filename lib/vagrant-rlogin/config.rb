module VagrantRLogin
  class Config < Vagrant.plugin(2, :config)
    # Program file absolute path or command name if found in PATH.
    # If value is undefined, search
    #   RLogin.exe
    #   C:\Program Files (x86)\RLogin\RLogin.exe
    #   C:\Program Files\RLogin\RLogin.exe
    #
    # @return [String]
    attr_accessor :exe_path

    # Template filename of the RLogin configuration file
    #
    # @return [String]
    attr_accessor :config_path

    def initialize
      @exe_path = UNSET_VALUE
      @config_path = UNSET_VALUE
    end

    def finalize!
      @exe_path = nil if @exe_path == UNSET_VALUE
      @config_path = nil if @config_path == UNSET_VALUE
    end
  end
end
