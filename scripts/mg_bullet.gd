extends Area2D

var vel = 320
var dir = Vector2()

onready var initpos = self.global_position

func _physics_process(delta):
	translate(dir * vel * delta)
	
	if global_position.distance_to(initpos) > 150:
		queue_free()