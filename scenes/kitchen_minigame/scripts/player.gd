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
			var npc_node = area.get_parent()
			if not npc_node or not ("pedido_nome" in npc_node):
				continue  # NPC ainda sem pedido

			var npc_pedido_nome = npc_node.pedido_nome
			var food_inst = GlobalM1.currently_being_hold_food

			if is_holding and food_inst and food_inst.name == npc_pedido_nome:
				print("Pedido correto entregue para NPC:", npc_node.name)

				# Somar pontos com base no preço
				if FoodData.get_food_by_name(npc_pedido_nome):
					var food_info = FoodData.get_food_by_name(npc_pedido_nome)
					GlobalM1.total_points += food_info.get("base_price", 0)
					print("Pontos adicionados:", food_info.get("base_price", 0))
					print(GlobalM1.total_points ," pontos atuais")
				else:
					var food_info = FoodData.get_food_by_name(npc_pedido_nome)
					print("Erro: comida", food_info.get("name"), "não encontrada em FoodData")
					

				# Entregar o pedido
				if npc_node.has_method("pedido_entregue"):
					npc_node.pedido_entregue()

				is_holding = false
				GlobalM1.currently_being_hold_food = null
				foodSprite.texture = null
				break
