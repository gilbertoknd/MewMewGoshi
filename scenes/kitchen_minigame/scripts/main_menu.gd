extends Control

@onready var botao_jogar = $CenterContainer/VBoxContainerExterno/VBoxContainerInterno/JogarButton
@onready var botao_sair = $CenterContainer/VBoxContainerExterno/VBoxContainerInterno/SairButton

func _ready():
	botao_jogar.pressed.connect(_on_jogar_pressed)
	botao_sair.pressed.connect(_on_sair_pressed)

func _on_jogar_pressed():
	get_tree().change_scene_to_file("res://scenes/kitchen_minigame/scenes/game.tscn")

func _on_sair_pressed():
	get_tree().quit()
