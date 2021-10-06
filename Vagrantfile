# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.provider "docker" do |d|
    d.build_dir = "."
    d.build_args = {
      "INPUT_DIR" => "hello"
    }
    # configure docker container 
    d.create_args = ['--cpuset-cpus=4']
    d.create_args = ['--memory=10g']
    d.remains_running = true
  end
end
