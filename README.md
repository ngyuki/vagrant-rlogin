# Vagrant RLogin Plugin

This is a Vagrant plugin that enables to ssh into vm with RLogin.

## Installation

```
vagrant plugin install vagrant-rlogin
```

## Usage

```
vagrant rlogin
```

## Configuration

```ruby
Vagrant.configure(2) do |config|
  # ...
  config.rlogin.exe_path = 'C:\Program Files (x86)\RLogin\RLogin.exe'
  config.rlogin.config_path = 'C:\Users\username\.vagrant.d\rlogin.rlg'
  # ...
end
```

* ```exe_path``` A RLogin.exe file path. We will find real path
  * If set and executable, use it.
  * If set and not executable, search in PATH.
  * If not set, search "RLogin.exe" in PATH.
  * If not found in PATH, use 'C:\Program Files (x86)\RLogin\RLogin.exe'
 or 'C:\Program Files\RLogin\RLogin.exe'
* ```config_path``` Template filename of the RLogin configuration file

## Thanks

Vagrant ( https://github.com/https://github.com/mitchellh/vagrant )
vagrant-multi-putty ( https://github.com/nickryand/vagrant-multi-putty )
vagrant-teraterm ( https://github.com/tiibun/vagrant-teraterm )
