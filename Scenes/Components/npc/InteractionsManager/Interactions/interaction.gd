@icon("res://Scenes/Components/npc/InteractionsManager/Interactions/NodeIcons/interaction_node_icon.png")
class_name Interaction
extends Node
# This is a dialog interaction, we put it here to "queue" up a dialog, and store 
# all of it's relevant information including the, localization "keys", flags that the 
# dialog REQUIRES, and flags that completeing the dialog will trip. 

# Export Vars
@export
var dialog_keys : Array[String] = []
@export
var required_flag : String
@export
var flag_on_completion : String

# References
@onready var interact_component: interact_component = $"../../InteractComponent"
@onready var npc: StaticBody3D = $"../.."





func interaction():
		# Connect the method we want the "DialogManager Server" to trigger when we end the event
		DialogManager.dialogue_complete.connect(interact_component._event_end)
		
		# Translate each of the lines, This should be done in DIALOGSERVER, but for the sake 
		# of learning and getting this done im doing it here for now. 
		var lines : Array[String] = []
		for key in dialog_keys :
			lines.push_back(tr(key))
		# offset predefined in text_box
		var text_box_position = npc.camera_3d.unproject_position(npc.global_position)
	
		DialogManager.start_dialog(text_box_position, lines, npc.mouth_sprite, npc.pitch)
		
		await DialogManager.dialogue_complete
		if flag_on_completion:
			npc.stage.stage_flags_resource.trip_flag(flag_on_completion)
			# Our parent is the interactions manager THIS LINE NEEDS TO CHANGE WHEN WE ADD SAVING AND LOADING
			get_parent().interaction_index += 1
		# Disconnect when we are done
		DialogManager.dialogue_complete.disconnect(interact_component._event_end)
