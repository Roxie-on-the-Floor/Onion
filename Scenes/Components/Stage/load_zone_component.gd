class_name load_zone_component
extends Area3D

@onready var world = $"../../../"
@export_dir
var transition_to : String
@export
var access_name : String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body):
	if body.name == "Player":
		world.transition_to(transition_to, access_name)
