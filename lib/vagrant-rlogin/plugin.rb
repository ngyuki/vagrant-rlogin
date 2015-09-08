require "vagrant"

module VagrantRLogin
  class Plugin < Vagrant.plugin("2")
    name "RLogin Plugin"
    description <<-DESC
    This plugin enables to ssh into vm using RLogin.
    DESC

    command "rlogin" do
      require_relative "command"
      Command
    end

    config "rlogin" do
      require_relative "config"
      Config
    end
  end
end
