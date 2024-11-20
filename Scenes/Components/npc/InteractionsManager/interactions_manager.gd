class_name InteractionsManager
extends Node
# Interactions managers manages "interactions", which are nodes that are children
# of the interaction manager. The interactions manager then sorts them and manages the
# interactions by queuing them and locking some of them behind flags.
@onready var interact_component: interact_component = $"../InteractComponent"


# Script Vars
var interaction_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set language for our dialog
	interact_component.event_start.connect(start_interaction)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_interaction():
	var interaction : Interaction = get_child(interaction_index)
	if interaction:
		# Check if the flag has been tripped before we start this interaction
		# This is an absolutely disgusting line of code and will probably make people mad at me. 
		if interaction.required_flag:
			if get_parent().stage.stage_flags_resource.check_for_flag(interaction.required_flag):
				interaction.interaction()
		else:
			interaction.interaction()
