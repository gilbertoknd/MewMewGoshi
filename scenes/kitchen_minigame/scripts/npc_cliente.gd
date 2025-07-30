extends CharacterBody3D

@onready var sprite_visual = $NpcSprite3D
@onready var pedido_icon = $NpcIconPedidoSprite3D

#Skins aleatorias para os clientes, salvar em .tres para usar as animacoes
var skins = [
	preload("res://scenes/kitchen_minigame/assets/sprites/clientes/npc_cliente_01.tres")
	#preload("res://scenes/kitchen_minigame/assets/sprites/clientes/npc_cliente_02.tres")
]

#Substituir por sprites (path)
var cardapio = [
	"Cafe", 
	"Bolo", 
	"Sorvete"
	]

var posicoes_mesas: Dictionary = {
	Vector3(-5, 1, -2) : 0,
	Vector3(-2, 1, -4) : 0,
	Vector3(1, 1, -4) : 0,
	Vector3(4, 1, -3) : 0
}

var mesa_selecionada : Vector3
var pedido_atual: Texture

func _ready() -> void:
	global_position = Vector3(1, 1, -4)
	
	#Porta (9, -4)
	
	#Assentos, da esquerda para a direita
	#(-5, -2) Assento 1
	#(-2, -4) Assento 2
	#(1, -4) Assento 3
	#(4, -3) Assento 4
	
	#Mesas na mesma ordem
	#(-5, -3) Mesa 1
	#(-2, -3) e (-1, -3) Mesa 2
	#(2, -3) e (2, -4) Mesa 3
	#(5, -3) Mesa 4
	
	#Saindo da porta (9, -4)
	#Pathing para o assento 1
	#Para (1, -4) : Caminhar até (4, -4) depois (4, -5) depois (-2, -5) depois (-4, -5) e (-4, -3), 
	#Direction (-4, -3) - (-5, -3) = (-1, 0) virar para a esquerda 
	
	#Pathing para o assento 2
	#Para (1, -4) : Caminhar até (4, -4) depois (4, -5) depois (-2, -5) e (-2, -4)
	#Direction (-2, -4) - (-2, -3) = (0, -1) virar para baixo
	
	#Pathing para o assento 3
	#Para (1, -4) : Caminhar até (4, -4) depois (4, -5) depois (1, -5) e (1, -4)
	#Direction (1, -4) - (2, -4) = (-1, 0) virar para a esquerda
	
	#Pathing para o assento 4
	#Para (4, -3) : Caminhar até (4, -4) depois (4, -3)
	#Direction (4, -3) - (5, -3) = (1, 0) virar para direita

	

	
	#gerar_pedido()
	aplicar_skin_aleatoria()
	
#Aleatorizando skin para o cliente	
func aplicar_skin_aleatoria():
	var skin_path = skins[randi() % skins.size()]
	sprite_visual = skin_path
	
func checar_mesa_vazia():
	var mesa_selecionada = posicoes_mesas[randi() % posicoes_mesas.size()]
	
	
#Aleatorizando pedido dentro do vetor do cardapio, no script glogal GameManager
func gerar_pedido():
	var pedido_atual = load(cardapio[randi() % cardapio.size()])

func mostrar_pedido():
	pedido_icon.texture = pedido_atual
	pedido_icon.visible = true
	pedido_icon.billiboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	
func _physics_process(delta: float) -> void:
	var direction = (mesa_selecionada - global_transform.origin)
	direction.y = 1
	
	if global_position == mesa_selecionada:
		sprite_visual.play("idle_down")
		mostrar_pedido()
	
	else:
		move_and_slide()

	#Mudar a direcao do sprite, mudando animacao
	if abs(direction.x) > abs(direction.z):
		if direction.x > 0: "walking_right"
		else: "walking_left"
	else:
		if direction.z > 0: "walking_up"
		else: "walking_down"
