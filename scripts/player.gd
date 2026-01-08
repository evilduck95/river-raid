extends RigidBody2D

class_name Player

var bullet = preload("res://scenes/bullet.tscn")

@onready var bullet_manager: Node = $"../BulletManager"
@onready var plane_model: PlaneModel = $PlaneModelProjection/SubViewport/Node3D/FighterPlane
@onready var plane_model_projection = $PlaneModelProjection
@onready var bullet_flash_sprite = $BulletFlash

# Movement
@export var acceleration = 100
@export var max_speed = 200
@export var damping = 10

# Firing
@export var fire_rate: int = 5
@export var bullet_flash_time: float = .1

var velocity = Vector2.ZERO
var current_rotation: float = 0
var time_per_bullet: float
var last_bullet_fired: float = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_constant_central_force(Vector2.RIGHT * 10)
	time_per_bullet = 1000.0 / fire_rate

func _process(_delta: float) -> void:
	if Input.is_action_pressed("fire") and (Time.get_ticks_msec() - last_bullet_fired) > time_per_bullet:
		bullet_flash()
		var fired_bullet = bullet.instantiate()
		bullet_manager.add_child(fired_bullet)
		fired_bullet.position = position + transform.x * 50
		fired_bullet.rotation = current_rotation + PI / 2
		last_bullet_fired = Time.get_ticks_msec()

func bullet_flash() -> void:
	bullet_flash_sprite.visible = true
	await get_tree().create_timer(bullet_flash_time).timeout
	bullet_flash_sprite.visible = false
	

func _physics_process(delta: float) -> void:
	var input_vector = Vector2(0, remap(current_rotation, -PI / 8, PI / 8, -max_speed, max_speed))
	#print("Input ", input_vector, input_vector.length())
	if input_vector.length() > 10:
		velocity += input_vector * acceleration
		velocity = velocity.clampf(-max_speed, max_speed)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, damping)
	move_and_collide(velocity * delta)
	rotation = current_rotation
	plane_model_projection.rotation = -current_rotation
	


func model_rotated(new_rotation: float):
	current_rotation = new_rotation
