extends MarginContainer

# References
@onready var label: Label = $MarginContainer/Label
@onready var timer: Timer = $LetterDisplayTimer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

#Script vars
const MAX_WIDTH = 768

var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.02

var input_command

# For audio
var letter_streams
var phonics_list 
var current_stream

# Signals
signal finished_displaying()


func _ready():
	phonics_list = list_files_in_directory("res://Assets/Audio/Phonics/")

func display_text(text_to_display: String, pitch: int):
	text = text_to_display
	label.text = text_to_display

	audio_player.pitch_scale = pitch
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized 
		custom_minimum_size.y = size.y
	global_position.x -= size.x / 2
	global_position.y -= size.y + 240
	
	label.text = ""
	_display_letter()

func _display_letter():
	phonics_list = list_files_in_directory("res://Assets/Audio/Phonics/")
	if text[letter_index] != "\\":
		label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return
	
	match text[letter_index]:
		# Play our puncutation timer
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		#Play our space timer
		" ": 
			timer.start(space_time)
		_:
			timer.start(letter_time)
			var new_audio_player = audio_player.duplicate()
			if text[letter_index].to_lower() in ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",]:
				for audio_stream in phonics_list:
					if audio_stream.resource_path.get_file().begins_with(text[letter_index].to_lower()):
						new_audio_player.stream = audio_stream
						break
				
			get_tree().root.add_child(new_audio_player)
			new_audio_player.play()
			await new_audio_player.finished
			new_audio_player.queue_free()

func list_files_in_directory(path):
	var files = []
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") && not file.contains(".import"):
			files.append(load(path + file))
	return files
	

func _on_letter_display_timer_timeout() -> void:
	_display_letter()
