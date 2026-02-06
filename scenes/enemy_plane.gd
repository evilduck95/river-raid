extends Sprite2D

class_name Enemy

@export var propellor: Node3D 
@export var propellor_speed: float

@onready var root_3d = $"SubViewport/3DRoot"
@onready var model = $"SubViewport/3DRoot/Model"
@onready var explosion_prefab = preload("res://scenes/plane_explosion.tscn")
@onready var hitbox_area = $Area2D
@onready var hitbox_shape = $Area2D/CollisionShape2D


var health = 50
var starting_rotation = PI

func _ready() -> void:
	model.rotate(Vector3.UP, starting_rotation)
	var propellor_tween = get_tree().create_tween()
	var plane_tween = get_tree().create_tween()
	propellor_tween.set_loops(2)
	propellor_tween.set_ease(Tween.EASE_OUT)
	propellor_tween.set_trans(Tween.TRANS_BACK)
	propellor_tween.tween_property(model, "rotation:x", 2 * PI, 3)
	plane_tween.set_loops(0)
	plane_tween.set_ease(Tween.EASE_OUT)
	plane_tween.set_trans(Tween.TRANS_QUART)
	plane_tween.tween_property(model, "rotation:y", 0, 5)


func _process(delta: float) -> void:
	propellor.rotate(Vector3.UP, propellor_speed * delta)

func explode():
	var explosion: PlaneExplosion = explosion_prefab.instantiate()
	explosion.set_collision_shape(hitbox_shape)
	hitbox_area.queue_free()
	add_child(explosion)
	var fade_out = get_tree().create_tween()
	fade_out.tween_property(self, "modulate:a", 0, 3.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
	await fade_out.finished
	self.queue_free()


func take_damage(amount):
	if health <= 0:
		return
	health -= amount
	if health <= 0:
		explode()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(10)
		
func set_3d_offset(offset: float):
	root_3d.position.x = offset
