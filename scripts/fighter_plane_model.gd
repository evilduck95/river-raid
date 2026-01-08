extends Node3D

class_name PlaneModel

@onready var player: Player = $"../../../.."
@onready var propeller_axis: Node3D = $FighterPlaneModel/PropellerAxis
@onready var propellor_parts = [$FighterPlaneModel/Propeller1, $FighterPlaneModel/Propeller3, $FighterPlaneModel/Propeller2]

@export var propellor_rotation_speed: float
@export var max_rotation: float = PI / 8
@export var rotation_speed: float = PI / 2

var current_y_velocity: float
var max_speed: float = 0

var rotation_snappiness: float = 7.5
var return_speed: float = .5
var target_rotation: Vector3

func _ready() -> void:
#	The propellors must rotate about the overall propellor axis
	for wing in propellor_parts:
		wing.global_transform.origin = propeller_axis.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input_vector = Vector2(0, Input.get_action_strength("down") - Input.get_action_strength("up")).normalized()
	if input_vector != Vector2.ZERO and abs(rotation.x) < max_rotation:
		var rotation_amount = -rotation_speed * input_vector.y * delta
		rotate(Vector3.LEFT, rotation_amount)
	elif input_vector == Vector2.ZERO:
		var abs_x_rot = abs(rotation.x)
		var snappiness_enhancement = 1
		if abs_x_rot > 0:
			if abs_x_rot < PI / 32:
				snappiness_enhancement = 2
			if abs_x_rot < .01:
				rotation.x = 0
			rotation = rotation.slerp(Vector3.ZERO, snappiness_enhancement * rotation_snappiness * delta)
	player.model_rotated(rotation.x)
	#	Non-fps dependent rotation
	var actual_rotation = propellor_rotation_speed * delta
#	For each individual wing on the propellor
	for wing in propellor_parts:
#		Rotate about global transform origin
		wing.rotate(Vector3.BACK, actual_rotation)
