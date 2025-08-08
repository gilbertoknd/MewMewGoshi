# Background.gd
extends Node2D   # <<-- troque CanvasLayer por Node2D

@export var pattern:Texture2D
@export var speed:float = 100.0
@export var direction:Vector2 = Vector2(1,1).normalized()

var _offset := Vector2.ZERO

func _process(delta: float) -> void:
	_offset += direction * speed * delta
	# faz wrap para ficar seamless
	_offset.x = fposmod(_offset.x, pattern.get_width())
	_offset.y = fposmod(_offset.y, pattern.get_height())
	update()  # pede pra chamar _draw()

func _draw() -> void:
	var screen_size = get_viewport().get_visible_rect().size
	var tw = pattern.get_width()
	var th = pattern.get_height()
	for x in range(0, screen_size.x + tw, tw):
		for y in range(0, screen_size.y + th, th):
			draw_texture(pattern, Vector2(x,y) - _offset)
