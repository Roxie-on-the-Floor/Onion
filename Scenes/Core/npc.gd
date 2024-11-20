extends StaticBody3D

# Export vars 
@export
var mouth_sprite : AnimatedSprite2D
@export
var pitch : int

# References 
@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var interact_component: interact_component = $InteractComponent
@onready var stage: Stage = $"../../"  #Located at NPCS/STAGE                            
@onready var interactions_manager: InteractionsManager = $InteractionsManager


# Player Reference I WANT TO PREFERABLY CHANGE THIS LATER
@onready var player : CharacterBody3D = $"../../../Player" #Located at NPCS/STAGE/WORLD/PLAYER
@onready var camera_3d :Camera3D = $"../../../Player/Sprite3D/Camera3D"
