extends Sprite2D

class_name Enemy

@export var propellor: Node3D 
@export var propellor_speed: float

var explosion_prefab = preload("res://scenes/plane_explosion.tscn")

@onready var root_3d = $"SubViewport/3DRoot"
@onready var model = $"SubViewport/3DRoot/Model"
@onready var hitbox_area = $Area2D
@onready var hitbox_shape = $Area2D/CollisionShape2D

var health = 50
var starting_rotation = PI + randf_range(0, PI / 16)
var rotation_wobble: float = PI / 128
var current_rotation_tween: Tween
var wobble_timing: float = 2 + randf()
var max_vertical_movement: int = 50

func _ready() -> void:
	model.rotate(Vector3.UP, starting_rotation)
	var rotation_tween = get_tree().create_tween()
	var plane_tween = get_tree().create_tween()
	rotation_tween.set_loops(2)
	rotation_tween.set_ease(Tween.EASE_OUT)
	rotation_tween.set_trans(Tween.TRANS_BACK)
	rotation_tween.tween_property(model, "rotation:x", 2 * PI, 1)
	rotation_tween.finished.connect(func (): model.rotation.x = 0)
	plane_tween.set_loops(0)
	plane_tween.set_ease(Tween.EASE_OUT)
	plane_tween.set_trans(Tween.TRANS_QUART)
	plane_tween.tween_property(model, "rotation:y", 0, 5)
	propellor_speed = propellor_speed + randf_range(-10, 20)
	current_rotation_tween = rotation_tween
	current_rotation_tween.finished.connect(wobble)
	get_tree().create_timer(randi() % 10).timeout.connect(func(): move([-1, 1].pick_random(), randf_range(-max_vertical_movement, max_vertical_movement)))


func _process(delta: float) -> void:
	propellor.rotate(Vector3.UP, propellor_speed * delta)

func wobble():
	var transition = Tween.TRANS_SINE
	var easing = Tween.EASE_IN_OUT
	var left = get_tree().create_tween().set_ease(easing).set_trans(transition)
	await left.tween_property(model, "rotation:x", -rotation_wobble, wobble_timing / 2).finished
	var right = get_tree().create_tween().set_ease(easing).set_trans(transition)
	right.tween_property(model, "rotation:x", rotation_wobble, wobble_timing / 2).finished.connect(wobble)

func move(direction: int, amount: float):
	var rot = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	rot.tween_property(model, "rotation:z", direction * PI / 32, 2)
	await get_tree().create_timer(1).timeout
	var movement = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	movement.tween_property(self, "position:y", position.y - (direction * amount), 2)
	await get_tree().create_timer(1).timeout
	var level_out = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	level_out.tween_property(model, "rotation:z", 0, 1)
	await get_tree().create_timer(randi() % 10).timeout
	move([-1, 1].pick_random(), randf_range(-max_vertical_movement, max_vertical_movement))

func explode():
	current_rotation_tween.kill()
	var explosion: PlaneExplosion = explosion_prefab.instantiate()
	# Hitbox passed in, required parts are copied out and it's safe to queue free if we wish
	explosion.set_collision_shape(hitbox_shape)
	hitbox_area.queue_free()
	add_child(explosion)
	var fade_out = get_tree().create_tween()
	fade_out.tween_property(self, "modulate:a", 0, 3.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
	await fade_out.finished
	self.queue_free()

func take_damage(amount):
	# I'm only checking less than 0 to be sure I catch any damage more than the current health
	if health <= 0:
		return
	health -= amount
	if health <= 0:
		explode()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(10)
		
func set_3d_offset(position_offset: float):
	root_3d.position.x = position_offset
