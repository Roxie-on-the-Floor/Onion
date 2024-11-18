class_name interact_component
extends Area3D

# Description: A node for npcs to hold and manage thier interaction event.
#              for this to work you must connect the event_start signal to
#              the method you want it to trigger, preferably within code instead
#              of the editor for the sake of organization. 

# Signals 
signal event_start
signal event_end

# Script vars
var can_interact = true

func _event_end():
	can_interact = true
	event_end.emit()
