extends Area3D

# Description: Allows the player to interact with npcs / npc actions / interactable objects 
#              the component locks players movement and detects interact_components, and calls
#              upon their interact method if valid. 
# References
@onready var player: CharacterBody3D = $".."

# Script vars
var interactable

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _unhandled_input(event: InputEvent) -> void:
	if interactable:
		if event.is_action_pressed("interact") && interactable.can_interact == true:
			# Set the interactable can_interact var to false.
			interactable.can_interact = false
			interactable.event_start.emit()
			# Lock the player movement until
			player.is_locked = true
			await interactable.event_end
			player.is_locked = false


func _on_area_entered(area):
	if area is interact_component:
		interactable = area
	
func _on_area_exited(area):
	if area is interact_component:
		interactable = null 
