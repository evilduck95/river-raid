extends Node2D

@export var player: Node2D

@onready var enemies = [
	{
		"prefab": preload("res://scenes/enemy_1.tscn"), 
		"chance": .1,
		"scale": .5
	}
]

var last_3d_spawn_position = 20
var spawn_check_delay = 200
var last_spawn_check = 0


func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - last_spawn_check > spawn_check_delay:
		for enemy in enemies:
			if randf() < enemy['chance']:
				var enemy_instance: Enemy = enemy['prefab'].instantiate()
				enemy_instance.scale *= enemy['scale']
				add_child(enemy_instance)
				enemy_instance.position.y += randi() % int(get_viewport_rect().size.y)
				enemy_instance.position.x = player.position.x + get_viewport_rect().size.x + 100
				enemy_instance.set_3d_offset(last_3d_spawn_position)
				last_3d_spawn_position += 20
		last_spawn_check = Time.get_ticks_msec()
