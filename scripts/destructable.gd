extends Area2D

export var health = 30

func hit(damage, node):
	health -= damage
	if health <= 0:
		$"../".queue_free()