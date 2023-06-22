class_name Enemy extends Area2D

@export var speed = 150
@export var hp = 1
@export var points = 10

signal killed(points)

func _physics_process(delta):
	global_position.y += speed * delta

func die():
	queue_free()

func _on_body_entered(body):
		if body is Player:
			body.die()
			queue_free()

func take_damage(amount):
	hp -= amount
	if hp <= 0:
		killed.emit(points)
		die()
