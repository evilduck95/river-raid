extends RigidBody2D

class_name Player

@onready var plane_model: PlaneModel = $PlaneModelProjection/SubViewport/Node3D/FighterPlane

@export var acceleration = 100
@export var max_speed = 200
@export var damping = 10

var velocity = Vector2.ZERO
var current_rotation: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_constant_central_force(Vector2.RIGHT * 10)
	plane_model.set_max_velocity(max_speed)


func _physics_process(delta: float) -> void:
	var input_vector = Vector2(0, remap(current_rotation, -PI / 8, PI / 8, -max_speed, max_speed))
	#print("Input ", input_vector, input_vector.length())
	if input_vector.length() > 10:
		velocity += input_vector * acceleration
		velocity = velocity.clampf(-max_speed, max_speed)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, damping)
	move_and_collide(velocity * delta)


func pass_rotation(new_rotation: float):
	current_rotation = new_rotation
