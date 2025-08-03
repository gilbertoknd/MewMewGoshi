extends CharacterBody3D

@onready var sprite := $AnimatedSprite3D
@onready var foodSprite := $FoodSprite
@onready var playerArea := $PlayerArea

@onready var is_holding = false

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var frame :=1
@export_enum("up", "left", "right", "down") var facing := "down"


func _ready():
	add_to_group("player")

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("M_left"):
		for area in playerArea.get_overlapping_areas():
			if area.is_in_group("moving_food"):
				var moving_food = area.get_parent()
				if moving_food.has_method("get_food_instance"):
					var food_instance = moving_food.get_food_instance()
					
					GlobalM1.currently_being_hold_food = food_instance
					foodSprite.texture = food_instance.sprite
					is_holding = true
					moving_food.queue_free()
					break  # pega só um alimento
	
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
		if is_holding:
			anim_name = "holding_" + facing
		sprite.play(anim_name)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		sprite.stop()
		sprite.frame = 0 
	
	checar_entrega_pedido()
	move_and_slide()
	
func checar_entrega_pedido() -> void:
	for area in playerArea.get_overlapping_areas():
		if area.is_in_group("npc"):
			# Supondo que o NPC tem script com pedido_atual
			var npc_node = area.get_parent()  # ou area se for o nó principal do NPC
			if npc_node.has_method("pedido_atual") or npc_node.get("pedido_atual"):
				var npc_pedido = npc_node.pedido_atual
				if npc_pedido == null:
					continue  # NPC sem pedido ainda

				if is_holding and GlobalM1.currently_being_hold_food and npc_pedido["name"] == GlobalM1.currently_being_hold_food.name:
					print("Pedido correto entregue para NPC: ", npc_node.name)
					# Chamar método do NPC para entregar pedido
					if npc_node.has_method("entregar_pedido"):
						npc_node.entregar_pedido()

					# Limpar pedido do player
					is_holding = false
					GlobalM1.currently_being_hold_food = null
					foodSprite.texture = null
					break  # entregou, sai do loop
