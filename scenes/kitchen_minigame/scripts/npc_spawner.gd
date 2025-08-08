extends Node

@onready var npc_scene: PackedScene = preload("res://scenes/kitchen_minigame/scenes/npc_cliente.tscn")
@export var spawn_interval: float = 10.0

var tempo := 0.0

func _process(delta):
	tempo -= delta
	if tempo <= 0.0:
		spawn_npc_se_possivel()
		tempo = spawn_interval

func spawn_npc_se_possivel():
	# Verificar se existe pelo menos uma mesa livre
	var mesa_livre = false
	for dados in MesaData.paths.values():
		if dados["ocupado"] == 0:
			mesa_livre = true
			break

	# Se não houver mesa livre, não spawnar
	if not mesa_livre:
		return

	# Criar NPC na porta
	var npc = npc_scene.instantiate()
	npc.global_position = Vector3(9, 1, -4)
	get_tree().current_scene.add_child(npc)
	npc.add_to_group("npcs")
