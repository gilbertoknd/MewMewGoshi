extends CanvasLayer

@onready var score_label = $UI/ScoreLabel
@onready var timer_label = $UI/TimerLabel
@onready var countdown_timer = $CountdownTimer

var time_left := 180  # segundos

func _ready():
	update_score()
	update_timer()
	countdown_timer.start()

func _process(delta: float) -> void:
	update_score()
	
func update_score():
	score_label.text = "Score: %d" % GlobalM1.total_points

func update_timer():
	timer_label.text = format_time(time_left)

func format_time(seconds: int) -> String:
	var minutes = seconds / 60
	var secs = seconds % 60
	return "%02d:%02d" % [minutes, secs]

func game_over():
	#Criar tela de gameover
	print("Tempo esgotado!")
	get_tree().change_scene_to_file("res://scenes/kitchen_minigame/scenes/main_menu.tscn")


func _on_countdown_timer_timeout() -> void:
	time_left -= 1
	update_timer()

	if time_left <= 0:
		countdown_timer.stop()
		game_over()
