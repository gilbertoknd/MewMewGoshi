extends CharacterBody3D

@onready var sprite := $AnimatedSprite3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var frame :=1
@export_enum("up", "left", "right", "down") var facing := "down"

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("walk_left", "walk_right", "walk_foward", "walk_backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction.length()>0:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if abs(direction.x) > abs(direction.z):
			facing = "right" if direction.x > 0.1 else "left"
		else:
			facing = "down" if direction.z > 0.1 else "up"
		var anim_name = "walking_" + facing
		sprite.play(anim_name)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		sprite.stop()
		sprite.frame = 0 
			
	move_and_slide()
