class_name Stage

extends Node3D
@export 
var stage_flags_resource : Stage_Flags

signal trip_flag(key : String)

func _ready():
	# Connect the stage flag signal to the resource
	trip_flag.connect(stage_flags_resource.trip_flag)
