extends Node

var lives = 4 # serves as the index for resolutions and scaleFactors
var baseResolution = DisplayServer.window_get_size() # TODO: figure out difficulty scaling 
var resolutions = [Vector2i(640, 360), Vector2i(854, 480),  Vector2i(1280,720) , Vector2i(1920,1080)] # remove next patch
var currentResolution : Vector2 = baseResolution
var scaleFactors = [320.0/427, 427.0/640, 2.0/3, 1]
