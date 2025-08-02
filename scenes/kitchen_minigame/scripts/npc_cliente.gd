extends CharacterBody3D

#Porta (9, -4)

@onready var sprite_visual = $NpcSprite3D
@onready var pedido_icon = $NpcIconPedido

@export var velocidade := 2.0

var caminho_selecionado : Array
var pedido_atual : Texture
var indice_atual := 0
var mesa_selecionada : Vector3
var chegou_na_mesa := false
#Timers
var tempo_de_escolha: Timer
var tempo_de_espera_atendimento: Timer
var tempo_de_espera_pela_comida: Timer
var segundo_inicial = 3
var segundo_final = 8

#Skins aleatorias para os clientes, salvar em .tres para usar as animacoes
var skins = [
	preload("res://scenes/kitchen_minigame/assets/sprites/clientes/npc_cliente_01.tres")
	#preload("res://scenes/kitchen_minigame/assets/sprites/clientes/npc_cliente_02.tres")
]

var cardapio = [
	preload("res://scenes/kitchen_minigame/assets/sprites/food/001_coffe.png"), 
	preload("res://scenes/kitchen_minigame/assets/sprites/food/002_expresso.png"), 
	preload("res://scenes/kitchen_minigame/assets/sprites/food/17_burger_napkin.png"),
	preload("res://scenes/kitchen_minigame/assets/sprites/food/23_cheesecake_dish.png"),
	preload("res://scenes/kitchen_minigame/assets/sprites/food/27_chocolate_dish.png"),
	preload("res://scenes/kitchen_minigame/assets/sprites/food/35_donut_dish.png"),
	preload("res://scenes/kitchen_minigame/assets/sprites/food/39_friedegg_dish.png"),
	preload("res://scenes/kitchen_minigame/assets/sprites/food/43_eggtart_dish.png"),
	preload("res://scenes/kitchen_minigame/assets/sprites/food/45_frenchfries_dish.png"),
	preload("res://scenes/kitchen_minigame/assets/sprites/food/58_icecream_bowl.png"),
	preload("res://scenes/kitchen_minigame/assets/sprites/food/64_lemonpie_dish.png"),
	preload("res://scenes/kitchen_minigame/assets/sprites/food/87_ramen.png"),
	preload("res://scenes/kitchen_minigame/assets/sprites/food/93_sandwich_dish.png"),
	preload("res://scenes/kitchen_minigame/assets/sprites/food/98_sushi_dish.png"),
	preload("res://scenes/kitchen_minigame/assets/sprites/food/soft_drink_blue.png"),
	preload("res://scenes/kitchen_minigame/assets/sprites/food/soft_drink_green.png"),
	preload("res://scenes/kitchen_minigame/assets/sprites/food/soft_drink_red.png"),
	preload("res://scenes/kitchen_minigame/assets/sprites/food/soft_drink_yellow.png")
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
		"mesa_coord": [Vector3(5, 1, -3)],
			
		"path": [
			Vector3(4, 1, -4),
			Vector3(4, 1, -3) #Assento_4_coord
		],
		"ocupado": 0,
	}
}


func _ready() -> void:
	global_position = Vector3(9, 1, -4)
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
func escolher_pedido():
	var pedido_atual = cardapio[randi() % cardapio.size()]
	tempo_de_escolha = Timer.new()
	tempo_de_escolha.one_shot = true
	tempo_de_escolha.wait_time = (randf_range(segundo_inicial, segundo_final))
	tempo_de_escolha.timeout.connect(_on_tempo_de_escolha_timeout)
	add_child(tempo_de_escolha)
	tempo_de_escolha.start()

func mostrar_pedido():
	print("Entrou no mostrar pedido")
	pedido_icon.texture = pedido_atual
	pedido_icon.visible = true

func _on_tempo_de_escolha_timeout():
	print("Entrou no timeout")
	mostrar_pedido()

	
func _physics_process(delta: float) -> void:
	if indice_atual >= caminho_selecionado.size():
		velocity = Vector3.ZERO
		virar_para_mesa()
		escolher_pedido()
		chegou_na_mesa = true
		caminho_selecionado = []
		return
	
	var destino = caminho_selecionado[indice_atual]
	var direction = destino - global_transform.origin
	direction.y = 0  # manter no plano

	if direction.length() > 0.1:
		direction = direction.normalized()
		velocity = direction * velocidade
		move_and_slide()
		
		# Atualiza animação com base na direção
		if abs(direction.x) > abs(direction.z):
			if direction.x > 0:
				$NpcSprite3D.play("walking_right")
			else:
				$NpcSprite3D.play("walking_left")
		else:
			if direction.z > 0:
				$NpcSprite3D.play("walking_down")
			else:
				$NpcSprite3D.play("walking_up")
				
	else:
		indice_atual += 1
