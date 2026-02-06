extends Node2D

@onready var explosion = $AnimatedSprite2D

@export var damage: float = 10
@export var speed: float = 100

var has_hit = false


func _process(_delta: float) -> void:
	if has_hit and not explosion.is_playing():
		self.queue_free()
		
func _physics_process(delta: float) -> void:
	var velocity = transform.y * speed * delta
	position -= velocity

func _on_area_2d_area_entered(area: Area2D) -> void:
	var area_parent = area.get_parent()
	if area_parent is Enemy:
		area_parent.take_damage(damage)
		reparent(area_parent)
		speed = 0
		explosion.play("explode")
		has_hit = true
		
