#!/bin/env ruby

$dir = {
	src:      "./src",
	rb:       "./src/rb",
	samples:  "./src/samples",
	sections: "./src/sections"
}

require 'gosu'
require 'awesome_print'
require 'byebug'
require "#{$dir[:rb]}/Settings"
require "#{$dir[:rb]}/main"
require "#{$dir[:rb]}/Section"

$game = Game.new
$game.show

