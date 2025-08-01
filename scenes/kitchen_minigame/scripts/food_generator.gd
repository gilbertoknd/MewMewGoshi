extends Node3D

@export var moving_food_scene: PackedScene  # arraste a cena aqui no editor
@export var spawn_interval: float = 1.5

var timer := 0.0

func _process(delta):
	timer -= delta
	if timer <= 0.0:
		spawn_food()
		timer = spawn_interval

func spawn_food():
	var instance = moving_food_scene.instantiate()
	instance.global_position = global_position  # nasce na posição do gerador
	get_tree().current_scene.add_child(instance)
