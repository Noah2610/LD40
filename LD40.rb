#!/bin/env ruby

DIR = {
	src:      "./src",
	rb:       "./src/rb",
	samples:  "./src/samples",
	sections: "./src/sections",
	people:   "./src/people"
}

require 'gosu'
require 'awesome_print'
require 'byebug'
require "#{DIR[:rb]}/Settings"
require "#{DIR[:rb]}/Section"
require "#{DIR[:rb]}/Camera"
require "#{DIR[:rb]}/Controls"
require "#{DIR[:rb]}/MiniMap"
require "#{DIR[:rb]}/Person"
require "#{DIR[:rb]}/Group"
require "#{DIR[:rb]}/main"

$camera = nil
$game = Game.new
$game.show

