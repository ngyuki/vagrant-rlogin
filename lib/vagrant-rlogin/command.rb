require('optparse')
require('pathname')

module VagrantRLogin
  class Command < Vagrant.plugin(2, :command)
    def self.synopsis
      "connects to machine via SSH using RLogin"
    end

    def execute
      opts = OptionParser.new do |opts|
        opts.banner = "Usage: vagrant rlogin [vm-name...]"

        opts.separator ""
      end

      argv = parse_options(opts)
      return -1 if !argv

      with_target_vms(argv, single_target: true) do |vm|
        @config = vm.config.rlogin

        ssh_info = vm.ssh_info
        @logger.debug("ssh_info is #{ssh_info}")
        # If ssh_info is nil, the machine is not ready for ssh.
        raise Vagrant::Errors::SSHNotReady if ssh_info.nil?

        exe_path = find_exe_path(@config.exe_path)
        return -1 if !exe_path

        commands = [
            exe_path,
            "/ssh",
            "/ip", ssh_info[:host],
            "/port", ssh_info[:port],
            "/user", ssh_info[:username],
            "/inuse",
        ]

        if not generate_rlogin_config(commands, vm)
          return -1
        end

        @logger.debug(commands)
        do_process(commands)
      end
    end

    def find_exe_path(path)
      if not path.nil?
        return path if File.executable?(path)

        # search in PATH
        ENV['PATH'].split(File::PATH_SEPARATOR).each do |p|
          _p = Pathname(p) + path
          return _p.to_s if _p.executable?
        end
      else
        # search in PATH
        ENV['PATH'].split(File::PATH_SEPARATOR).each do |p|
          _p = Pathname(p) + 'RLogin.exe'
          return _p.to_s if _p.executable?
        end

        # Program Files
        ['C:\Program Files (x86)\RLogin\RLogin.exe',
         'C:\Program Files\RLogin\RLogin.exe'].each do |p|
           return p if File.executable?(p)
        end
      end

      @env.ui.error("File is not found or executable. => #{path}")
      nil
    end

    def absolute_winpath(vm, path)
      p = Pathname(path)
      return path.gsub(/\//, "\\") if p.absolute?
      return Pathname(vm.env.root_path).join(p).to_s.gsub(/\//, "\\")
    end

    def generate_rlogin_config(commands, vm)

      src = @config.config_path
      if src.nil?
        @env.ui.error("config_path notfound in rlogin config")
        nil
      end

      ssh_info = vm.ssh_info
      content = File.read(src)

      if ssh_info.include?(:password)
        commands << "/pass" << ssh_info[:password]
      elsif ssh_info.include?(:private_key_path)
        key = vm.ssh_info[:private_key_path][0]
        content.gsub!(/^Entry.IdKey=.*?$/, "Entry.IdKey=\"#{key}\";")
      end

      dst = File.join(vm.data_dir, "rlogin.rlg")
      File.write(dst, content)
      commands << dst
    end

    def do_process(commands)
      pid = spawn(commands.join(" "))
      Process.detach(pid)
    end
  end
end
