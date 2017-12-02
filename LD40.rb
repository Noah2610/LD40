#!/bin/env ruby

DIR = {
	src:      "./src",
	rb:       "./src/rb",
	samples:  "./src/samples",
	sections: "./src/sections"
}

require 'gosu'
require 'awesome_print'
require 'byebug'
require "#{DIR[:rb]}/Settings"
require "#{DIR[:rb]}/main"
require "#{DIR[:rb]}/Section"

$game = Game.new
$game.show

