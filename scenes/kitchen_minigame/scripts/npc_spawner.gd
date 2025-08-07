extends Node

@onready var npc_scene: PackedScene = preload("res://scenes/kitchen_minigame/scenes/npc_cliente.tscn")
@export var max_npcs: int = 4
@export var spawn_interval: float = 5.0

var tempo := 0.0

func _process(delta):
	tempo -= delta
	if tempo <= 0.0:
		spawn_npc_se_possivel()
		tempo = spawn_interval

func spawn_npc_se_possivel():
	# Checar se há menos de 4 NPCs ativos
	var npc_count = get_tree().get_nodes_in_group("npcs").size()
	if npc_count >= max_npcs:
		return

	# Verificar se existe alguma mesa livre

	#if not mesa_livre:
	#	return

	# Spawn do NPC
	var npc = npc_scene.instantiate()
	npc.global_position = Vector3(9, 1, -4)
	get_tree().current_scene.add_child(npc)
	npc.add_to_group("npcs")
