extends Node3D

@onready var sprite_3d: Sprite3D = $Sprite3D

var food_instance: FoodInstance
var speed := 2.0  # velocidade da esteira

func _ready():
	randomize()
	food_instance = FoodInstance.random()
	sprite_3d.texture = food_instance.sprite

func _process(delta):
	# Move no eixo X para a esquerda
	global_position.x -= speed * delta
