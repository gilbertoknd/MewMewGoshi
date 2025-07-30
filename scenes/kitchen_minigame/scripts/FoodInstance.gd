# FoodInstance.gd
extends Resource
class_name FoodInstance

var name: String
var sprite: Texture2D
var base_price: int

# Construtor aleatório baseado em spawn_weight
static func random() -> FoodInstance:
	var item_id = _get_random_food_id()
	return from_id(item_id)

# Cria instância a partir de um ID
static func from_id(food_id: String) -> FoodInstance:
	var data = FoodData.DATA[food_id]
	var instance = FoodInstance.new()
	instance.name = data["name"]
	instance.sprite = data["sprite"]
	instance.base_price = data["base_price"]
	return instance

# Função sorteio com base em spawn_weight
static func _get_random_food_id() -> String:
	var pool = []
	for key in FoodData.DATA.keys():
		var weight = FoodData.DATA[key].get("spawn_weight", 1)
		for i in weight:
			pool.append(key)
	return pool[randi() % pool.size()]
