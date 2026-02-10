extends Area2D

class_name PlaneExplosion

signal explosion_complete

var explosion_prefab = preload("res://scenes/explosion.tscn")

@onready var area_shape: CollisionShape2D = $CollisionShape2D
@onready var explosions_node = $Explosions
@onready var finale_explosion = $AnimatedSprite2D


@export var time_between_explosions: int = 100
@export var explosion_rate_deviation: int = 50
@export var explosion_duration = 1

var spawn_time: int

var last_explosion = 0
var wanted_explosion_shape = null
var finale_started = false

# Set lazily, have to be passed manually when explosion instantiated and added to tree
var explosion_position: Vector2
var explosion_extents: Vector2

func _ready() -> void:
	spawn_time = Time.get_ticks_msec()

func _process(_delta: float) -> void:
	if finale_started:
		if not finale_explosion.is_playing():
			explosion_complete.emit()
	else:
		if Time.get_ticks_msec() - spawn_time > explosion_duration * 1000:
			finale_explosion.play("explode")
			finale_started = true
		var deviation = randi_range(-explosion_rate_deviation, explosion_rate_deviation)
		if (Time.get_ticks_msec() - last_explosion) > (time_between_explosions + deviation):
			var next_position = get_random_position_in_area()
			var explosion = explosion_prefab.instantiate()
			explosion.position = next_position
			add_child(explosion)
			last_explosion = Time.get_ticks_msec()

func set_collision_shape(shape):
	print('Passed collision shape ', shape.shape, shape.position)
	explosion_position = shape.position
	explosion_extents = shape.shape.extents

func get_random_position_in_area() -> Vector2:
	var center = explosion_position
	var size = explosion_extents
	var x_pos = (randi() % int(size.x)) - (size.x / 2) + center.x
	var y_pos = (randi() % int(size.y)) - (size.y / 2) + center.y
	return Vector2(x_pos, y_pos)
