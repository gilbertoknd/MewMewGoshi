extends Node3D

@onready var progress_bar := $SubViewport/TextureProgressBar

@export var total_time := 20.0
var time_left := 0.0

func _ready():
	time_left = total_time
	progress_bar.max_value = total_time
	progress_bar.value = total_time

func _process(delta):
	if time_left > 0.0:
		time_left -= delta
		progress_bar.value = time_left
	else:
		progress_bar.value = 0
		queue_free()  # ou hide()
