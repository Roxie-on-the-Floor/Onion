extends CharacterBody3D

# Script Vars
var is_locked = false
const SPEED = 6.0
const JUMP_VELOCITY = 4.5

# References. 
@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var animation_player: AnimationPlayer = $SubViewport/OnionSprite/AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $SubViewport/OnionSprite/Skeleton2D/Root/Neck/Head/AnimatedSprite2D

# Process Movement
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta



	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction && !is_locked:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if input_dir && !is_locked:
		animation_player.play("Run")
	else:
		animation_player.play("Idle")
	
	if input_dir.y == -1 && !is_locked:
		animated_sprite_2d.visible = false
	elif input_dir.y == 1 && !is_locked:
		animated_sprite_2d.visible = true
	
	move_and_slide()
