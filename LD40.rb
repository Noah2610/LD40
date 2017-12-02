#!/bin/env ruby

dir = {
	src:      "./src",
	rb:       "./src/rb",
	samples:  "./src/samples",
	textures: "./src/textures",
}

$screen = {
	w: 640,
	h: 520
}

require "gosu"
require "#{dir[:rb]}/main"
require "#{dir[:rb]}/section"

$game = Game.new
$game.show

