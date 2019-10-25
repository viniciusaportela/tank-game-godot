extends Node2D

func _on_timer_queue_timeout():
	$fade_out.play("fade_out")
	yield($fade_out, 'animation_finished')
	queue_free()