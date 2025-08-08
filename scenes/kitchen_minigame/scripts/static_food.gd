extends Node3D

@onready var area := $Area3D
@onready var sprite := $Sprite3D

var food_instance: FoodInstance = null

func _ready():
	# Opcional: conectar via signal
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	
	# Detectar botão de interação
	if Input.is_action_just_pressed("M_left"):
		# Tentar PEGAR comida do StaticFood
		if food_instance and GlobalM1.currently_being_hold_food == null:
			GlobalM1.currently_being_hold_food = food_instance
			body.is_holding = true
			body.foodSprite.texture = food_instance.sprite
			food_instance = null
			sprite.texture = null
			print("Comida retirada do StaticFood.")

		# Tentar COLOCAR comida no StaticFood
		elif food_instance == null and GlobalM1.currently_being_hold_food:
			food_instance = GlobalM1.currently_being_hold_food
			GlobalM1.currently_being_hold_food = null
			body.is_holding = false
			body.foodSprite.texture = null
			sprite.texture = food_instance.sprite
			print("Comida colocada no StaticFood.")
