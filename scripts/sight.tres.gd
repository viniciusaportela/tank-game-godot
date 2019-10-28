tool
extends Node2D

func _draw():
	var color = Color(1, 0, 0)
	if get_parent().get_parent().loaded:
		color = Color(0, 1, 0)
	
	draw_circle(Vector2(), 4, color)