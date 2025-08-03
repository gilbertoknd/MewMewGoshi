extends CharacterBody3D

'''
Porta (9, -4)
	
Assentos, da esquerda para a direita
(-5, -2) Assento 1
(-2, -4) Assento 2
(1, -4) Assento 3
(4, -3) Assento 4

Mesas na mesma ordem
(-5, -3) Mesa 1
(-2, -3) e (-1, -3) Mesa 2
(2, -3) e (2, -4) Mesa 3
(5, -3) Mesa 4

Saindo da porta (9, -4)
Pathing para o assento 1
Para (-5, -2) : Caminhar até (4, -4) depois (4, -5) depois (-2, -5) depois (-4, -5) e (-4, -3), 
Direction (-4, -3) - (-5, -3) = (1, 0) virar para a esquerda 

Pathing para o assento 2
Para (-2, -4) : Caminhar até (4, -4) depois (4, -5) depois (-2, -5) e (-2, -4)
Direction (-2, -4) - (-2, -3) = (0, -1) virar para baixo

Pathing para o assento 3
Para (3, -4) : Caminhar até (3, -4)
Direction (3, -4) - (2, -4) = (1, 0) virar para esquerda

Pathing para o assento 4
Para (4, -3) : Caminhar até (4, -4) depois (4, -3)
Direction (4, -3) - (5, -3) = (-1, 0) virar para direita

(0, 1) seria virar para cima
'''

@onready var sprite_visual = $NpcSprite3D
@onready var pedido_icon = $NpcIconPedido
@onready var NpcArea = $NpcArea
@export var velocidade := 2.0

var caminho_selecionado : Array
var pedido_atual : Dictionary
var indice_atual := 0
var mesa_selecionada : Vector3
var spritePedido: Texture2D

var satisfeito := false

#Skins aleatorias para os clientes, salvar em .tres para usar as animacoes
var skins = [
	preload("res://scenes/kitchen_minigame/assets/sprites/clientes/npc_cliente_01.tres")
	#preload("res://scenes/kitchen_minigame/assets/sprites/clientes/npc_cliente_02.tres")
]


var caminhos_para_mesas: Dictionary = {
	"assento_1": {
		"mesa_coord": [Vector3(-5, 1, -3)],
			
		"path": [
			Vector3(4, 1, -4),
			Vector3(4, 1, -5),
			Vector3(-2, 1, -5),
			Vector3(-4, 1, -5),
			Vector3(-4, 1, -3) #Assento_1_coord
		],
		"ocupado": 0,
	},
	"assento_2": {
		"mesa_coord": [Vector3(-2, 1, -3)],
			
		"path": [
			Vector3(4, 1, -4),
			Vector3(4, 1, -5),
			Vector3(-2, 1, -5),
			Vector3(-2, 1, -4) #Assento_2_coord
		],
		"ocupado": 0,
	},
	
	"assento_3": {
		"mesa_coord": [Vector3(2, 1, -4)],
			
		"path": [
			Vector3(3, 1, -4) #Assento_3_coord
		],
		"ocupado": 0,
	},
	
	"assento_4": {
		"mesa_coord": [Vector3(-5, 1, -3)],
			
		"path": [
			Vector3(4, 1, -4),
			Vector3(4, 1, -3) #Assento_4_coord
		],
		"ocupado": 0,
	}
}


func _ready() -> void:
	global_position = Vector3(9, 1, -4)
	#gerar_pedido()
	aplicar_skin_aleatoria()
	selecionar_mesa()
	
#Aleatorizando skin para o cliente	
func aplicar_skin_aleatoria():
	var skin_path = skins[randi() % skins.size()]
	sprite_visual = skin_path
	
func selecionar_mesa():
	var livres: Array = []

	#Procurando assentos livres
	for destino in caminhos_para_mesas:
		var assento = caminhos_para_mesas[destino]
		if assento["ocupado"] == 0:
			livres.append(destino)
	#
	if not livres.is_empty():
		randomize()
		var escolha = livres[randi() % livres.size()]
		caminho_selecionado = caminhos_para_mesas[escolha]["path"]
		caminhos_para_mesas[escolha]["ocupado"] = 1
		mesa_selecionada = caminhos_para_mesas[escolha]["mesa_coord"][0]

func virar_para_mesa():
	if caminho_selecionado.is_empty():
		return
	
	var posicao_final = caminho_selecionado[-1]  #ultima posição do caminho (assento)
	var mesa_pos = mesa_selecionada
	
	#Subtraindo e convertendo pra Vector2
	var direcao = Vector2(
		mesa_pos.x - posicao_final.x,
		mesa_pos.z - posicao_final.z
	).normalized()

	#Decidir direção
	if direcao == Vector2.LEFT:
		$NpcSprite3D.animation = "walking_left"
		$NpcSprite3D.stop()
		$NpcSprite3D.frame = 0
		
		
	elif direcao == Vector2.RIGHT:
		$NpcSprite3D.animation = "walking_right"
		$NpcSprite3D.stop()
		$NpcSprite3D.frame = 0
		
	elif direcao == Vector2.UP:
		$NpcSprite3D.animation = "walking_up"
		$NpcSprite3D.stop()
		$NpcSprite3D.frame = 0
		
	elif direcao == Vector2.DOWN:
		$NpcSprite3D.animation = "walking_down"
		$NpcSprite3D.frame = 0
		$NpcSprite3D.stop()
		
	else:
		print("Direção inesperada:", direcao)

		
#Aleatorizando pedido dentro do vetor do cardapio, no script glogal GameManager
func gerar_pedido():
	var keys = FoodData.DATA.keys()
	randomize()
	var chosen_key = keys[randi() % keys.size()]
	var pedido = FoodData.DATA[chosen_key]
	pedido_atual = pedido
	spritePedido = pedido_atual["sprite"]

func mostrar_pedido():
	if pedido_atual:
		pedido_icon.texture = spritePedido
		pedido_icon.visible = true

func criar_timer_pedido():
	var timer_scene = preload("res://scenes/kitchen_minigame/scenes/timergenerator.tscn") # Substitua pelo caminho correto
	var timer_instance = timer_scene.instantiate()
	add_child(timer_instance)
	
	# Opcional: posicione no NPC ou na mesa
	timer_instance.global_position = global_position + Vector3(0, 2, 0)


func _physics_process(delta: float) -> void:
	# Se ainda não terminou o caminho
	if not caminho_selecionado.is_empty() and indice_atual < caminho_selecionado.size():
		var destino = caminho_selecionado[indice_atual]
		var direction = destino - global_transform.origin
		direction.y = 0
		if direction.length() > 0.1:
			direction = direction.normalized()
			velocity = direction * velocidade
			move_and_slide()
			# animação (como já estava)
		else:
			indice_atual += 1
	else:
		velocity = Vector3.ZERO
		virar_para_mesa()

		if not pedido_atual:
			gerar_pedido()
			mostrar_pedido()
			criar_timer_pedido()

func entregar_pedido():
	# Aqui pode fazer animação de agradecimento, som, pontuação etc.
	# Esconde ícone do pedido
	pedido_icon.visible = false
	satisfeito= true
	# Libera a mesa (se você rastreia ocupação em outro sistema, faça aqui também)
	# Exemplo: marcar mesa como livre (se tiver controle centralizado de mesas)
	
	# Remove NPC
	queue_free()
