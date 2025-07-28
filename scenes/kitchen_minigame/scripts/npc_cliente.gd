extends CharacterBody3D

@onready var sprite_visual = $NpcSprite3D
@onready var pedido_icon = $NpcIconPedidoSprite3D
@onready var nav_agent = $NpcNavigationAgent3D

#Skins aleatorias para os clientes, salvar em .tres para usar as animacoes
var skins = [
	preload("res://scenes/kitchen_minigame/assets/sprites/clientes/npc_cliente.tres")
]

#Substituir por sprites (path)
var cardapio = [
	"Café", 
	"Bolo", 
	"Sorvete"
	]

var pedido_atual: Texture

func _ready() -> void:
	gerar_pedido()
	aplicar_skin_aleatoria()
	mover_ate_o_balcao()
	
#Aleatorizando skin para o cliente	
func aplicar_skin_aleatoria():
	var skin_path = skins[randi() % skins.size()]
	var new_skin = load(skin_path).instantiate()
	
func mover_ate_o_balcao():
	var ponto_balcao = get_node_or_null("/root/game/mapa") #Inserir node com o ponto do balcao e referenciar aqui
	if ponto_balcao:
		nav_agent.target_position = ponto_balcao.global_transform.origin
		
#Aleatorizando pedido dentro do vetor do cardapio, no script glogal GameManager
func gerar_pedido():
	var pedido_atual = load(cardapio[randi() % cardapio.size()])

func mostrar_pedido():
	pedido_icon.texture = pedido_atual
	pedido_icon.visible = true
	pedido_icon.billiboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
			
func _physics_process(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		sprite_visual.play("idle_down")
		mostrar_pedido()
	else:
		var dir = nav_agent.get_next_path_position() - global_transform.origin
		dir.y = 0 #altura sempre a msm
		dir = dir.normalized()
		
		#Mudar a direcao do sprite, mudando animacao
		if abs(dir.x) > abs(dir.z):
			if dir.x > 0: "walking_right"
			else: "walking_left"
		else:
			if dir.z > 0: "walking_up"
			else: "walking_down"
			
