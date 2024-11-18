extends Node3D
# Node with methods for calling upon our loading screen and transitioning us between stages. 
# Called when the node enters the scene tree for the first time. The "world" basically manages the
# world and how it looks, managing the game state and evenets should ideally be done in core, and
# a flag system should be done in autoload

@onready var player: CharacterBody3D = $Player

var current_stage 

func _ready() -> void:
	# TEMPORARY
	current_stage = get_node("Stage")

# handle loading into the new stage
func transition_to(stage_path : String, to_name : String):
	player.is_locked = true
	LoadingUI.fade_in_visual()
	await LoadingUI.get_node("AnimationPlayer").animation_finished
	current_stage.queue_free()
	ResourceLoader.load_threaded_request(stage_path)
	
	# Get the status.
	var scene_load_status = ResourceLoader.load_threaded_get_status(stage_path)
	# While our stage is not loaded do nothing.
	# When we are done we assign the new scene to the thread get. 
	await ResourceLoader.THREAD_LOAD_LOADED
	var new_scene = ResourceLoader.load_threaded_get(stage_path).instantiate()
	add_child(new_scene)
	current_stage = new_scene
	
	# Find the entrance to the stage 
	var exits = current_stage.get_node("Exits")
	
	for exit : load_zone_component in exits.get_children():
		# If the name of our current exit is the same as the one we are trying to access
		if exit.access_name == to_name:
			# Set the players position to the exits entrance position
			var pos = exit.get_node("EntrancePosition").global_position
			print("Found correct position")
			player.global_position = pos
	
	LoadingUI.fade_out_visual()
	# Unlock the player movement
	# Update our player position to the new exit 
	player.is_locked = false
