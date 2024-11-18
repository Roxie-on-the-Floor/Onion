extends Node

# References 
@onready var text_box_scene = preload("res://Scenes/Components/Text/textbox.tscn")

# Script vars
var dialog_lines: Array[String] = []
var current_line_index = 0 

var text_box
var text_box_position: Vector2

var sfx: AudioStream
var speech_pitch
var is_dialog_active = false
var can_advance_line = false

var mouth

# Signals 
signal dialogue_complete

func start_dialog(position: Vector2, lines: Array[String], mouth_sprite: AnimatedSprite2D, pitch: int):
	if is_dialog_active:
		return
	
	dialog_lines = lines
	text_box_position = position
	
	speech_pitch = pitch
	
	_show_text_box()
	
	is_dialog_active = true
	mouth = mouth_sprite
	if mouth:
		mouth.play()
	

func _show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box)
	text_box.global_position = text_box_position
	text_box.display_text(dialog_lines[current_line_index], speech_pitch)
	can_advance_line = false
	if mouth:
		mouth.play()

func _on_text_box_finished_displaying():
	can_advance_line = true
	if mouth:
		mouth.stop()

func _unhandled_input(event):
	if (
		
		event.is_action_pressed("interact") && 
		is_dialog_active &&
		can_advance_line
	):
		text_box.queue_free()
		current_line_index += 1
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false
			current_line_index = 0
			print("completeting dialog")
			# Get rid of the mouth because godot doesnt like keeping it when we switch scenes
			mouth = null
			dialogue_complete.emit()
			return
			
		# If we do not meet the finish condition we show the text box

		_show_text_box()
	# Fast forward controls
	if event.is_action_pressed("cancel"):
		if text_box && is_dialog_active:
			text_box.letter_time = 0.002
			text_box.space_time = 0.005
			text_box.punctuation_time = 0.001
