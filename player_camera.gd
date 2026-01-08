extends Camera2D


var move_speed = 10

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_RIGHT):
		position.x += move_speed
	elif Input.is_key_pressed(KEY_LEFT):
		position.x -= move_speed
