extends Node3D

@onready var sprite_anim: AnimatedSprite3D = $AnimatedSprite3D

func _ready():
	sprite_anim.play("default")
	
func _process(_delta):
	if !sprite_anim.is_playing():
		sprite_anim.play("default")
