## -= IMPORTS =-
extends Node2D

## -= TIMER =-
func _on_timer_queue_timeout():
	# Iniciar FadeOut, Então deletar da cena
	$fade_out.play("fade_out")
	yield($fade_out, 'animation_finished')
	queue_free()