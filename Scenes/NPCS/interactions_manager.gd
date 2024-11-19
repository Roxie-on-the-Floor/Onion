class_name InteractionsManager
extends Node
# Interactions managers manages "interactions", which are nodes that are children
# of the interaction manager. The interactions manager then sorts them and manages the
# interactions by queuing them and locking some of them behind flags.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_interactions(interaction_name : String):
	pass
