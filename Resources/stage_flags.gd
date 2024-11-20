extends Resource
class_name Stage_Flags

@export 
var stage_flag_dict : Dictionary[String,bool] = {}


func trip_flag(key : String) -> void:
	for flag in stage_flag_dict:
		if key == flag:
			stage_flag_dict[flag] = true

func check_for_flag(key : String) -> bool:
	for flag in stage_flag_dict:
		if key == flag:
			return stage_flag_dict[flag]
	print("no flag found")
	return false
