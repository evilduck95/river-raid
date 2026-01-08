extends Node2D


@export var speed: float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var velocity = transform.y * speed * delta
	position -= velocity


func _on_collision_with_body(body: Node2D) -> void:
	#print("Collision with ", body.name)
	pass
