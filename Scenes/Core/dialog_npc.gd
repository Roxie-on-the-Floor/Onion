extends StaticBody3D

# References 
@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var interact_component: interact_component = $InteractComponent
@onready var stage: Stage = $"../../"  #Located at NPCS/STAGE                            
@onready var player : CharacterBody3D = $"../../../Player" #Located at NPCS/STAGE/WORLD/PLAYER
@onready var camera_3d :Camera3D = $"../../../Player/Sprite3D/Camera3D"
# Export vars 
@export
var mouth_sprite : AnimatedSprite2D
@export
var pitch : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interact_component.event_start.connect(_interaction)


func _interaction():
		# Connect the method we want the "DialogManager Server" to trigger when we end the event
		DialogManager.dialogue_complete.connect(interact_component._event_end)
		
		# We have some setup to do before we can start the dialog, we will get the textbox position
		# TO FIX this could probably be moved to the dialogmanager script
		var text_box_position = camera_3d.unproject_position(global_position)
		# Check which flag we are on, and then start the corresponding dialogue, we work in a "queue" type
		# deal and we stay on the last said dialog. 
		
		#DialogManager.start_dialog(text_box_position, lines, mouth_sprite, pitch)
		# Await the signal
		await DialogManager.dialogue_complete
		# Disconnect when we are done
		DialogManager.dialogue_complete.disconnect(interact_component._event_end)
