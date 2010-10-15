require 'yaml'

require 'engine/engine.rb'
require 'test_impl/test_impl.rb'

require 'ui/main.rb'

include RubyWars::Engine

fleet_builders_yml = YAML.load_file('fleets.yml')
system_yml = YAML.load_file('system.yml')

s = System.new(system_yml[:name], eval(system_yml[:size]))

fleet_builders_yml.each do |fb_txt|
  fb = eval("#{fb_txt}.new")
  s.deploy_fleet(fb)
end

window = RubyWars::UI::GameWindow.new
window.show
