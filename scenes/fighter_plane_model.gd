extends Node3D

@onready var propeller_axis: Node3D = $PropellerAxis
@onready var propellor_parts = [$Propeller1, $Propeller2, $Propeller3]

@export var propellor_rotation_speed: float

func _ready() -> void:
#	The propellors must rotate about the overall propellor axis
	for wing in propellor_parts:
		wing.global_transform.origin = propeller_axis.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
#	Non-fps dependent rotation
	var actual_rotation = propellor_rotation_speed * _delta
#	For each individual wing on the propellor
	for wing in propellor_parts:
#		Rotate about global transform origin
		wing.rotate(Vector3.BACK, actual_rotation)
	
func rotate_around_v2(object: Node3D, origin_position: Vector3, angle: float) -> void:
	var rotation_axis = Vector3.BACK
	var pivot_point = origin_position
	var pivot_transform = Transform3D(object.transform.basis, pivot_point)
	object.transform = pivot_transform.rotated(rotation_axis, angle)
