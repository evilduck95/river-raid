extends Camera2D

@export var player_position_in_frame: int = 200

@onready var player: RigidBody2D = $"../Player"

var move_speed = 10

func _process(_delta: float) -> void:
	position.x = player.position.x - player_position_in_frame
