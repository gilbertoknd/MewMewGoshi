extends Node3D

@onready var progress_bar := $SubViewport/TextureProgressBar

@export var total_time := 20.0
var time_left := 0.0

func _ready():
	time_left = total_time
	progress_bar.max_value = total_time
	progress_bar.value = total_time

signal timeout

func _process(delta):
	if time_left > 0.0:
		time_left -= delta
		progress_bar.value = time_left
	else:
		progress_bar.value = 0
		emit_signal("timeout")
		queue_free()
