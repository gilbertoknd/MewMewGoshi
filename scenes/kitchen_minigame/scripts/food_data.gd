extends Node
class_name FoodData

const DATA = {
	"CAFE": {
		"name": "Café",
		"spawn_weight": 30,
		"base_price": 8,
		"sprite": preload("res://scenes/kitchen_minigame/assets/sprites/food/001_coffe.png"),
	},
	"EXPRESSO": {
		"name": "Expresso",
		"spawn_weight": 30,
		"base_price": 8,
		"sprite": preload("res://scenes/kitchen_minigame/assets/sprites/food/002_expresso.png"),
	},
	"SANDUICHE": {
		"name": "Sando",
		"spawn_weight": 30,
		"base_price": 10,
		"sprite": preload("res://scenes/kitchen_minigame/assets/sprites/food/93_sandwich_dish.png"),
	},
	"HAMBURGUER": {
		"name": "Força Cósmica",
		"spawn_weight": 30,
		"base_price": 16,
		"sprite": preload("res://scenes/kitchen_minigame/assets/sprites/food/17_burger_napkin.png"),
	},
	"FRIES": {
		"name": "Batatas Fritas",
		"spawn_weight": 30,
		"base_price": 10,
		"sprite": preload("res://scenes/kitchen_minigame/assets/sprites/food/45_frenchfries_dish.png"),
	},
	}
	
static func get_food_by_name(food_name: String) -> Dictionary:
	for key in DATA:
		var item = DATA[key]
		if item.get("name", "") == food_name:
			return item
	return {}
