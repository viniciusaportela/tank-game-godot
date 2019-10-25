extends Area2D

#setget -> Quando modificada chama uma função
var dir = Vector2(0, -1) setget set_dir
var vel = 250
const MAX_DIST = 250

#global_position = posição dentro da cena, não do objeto
onready var init_pos = global_position

var live = true

func _ready():
	pass

func _process(delta):
	
	if live:
		if global_position.distance_to(init_pos) >= MAX_DIST:
			self_destroy()
		translate(dir * vel * delta)
	pass

func _on_VisibilityNotifier2D_screen_exited():
	#Apagar da memória, de modo seguro
	queue_free()
	pass # Replace with function body.

func set_dir(val):
	dir = val
	rotation = dir.angle()

func _on_bullet_body_entered(body):
	if body.collision_layer == 4:
		self_destroy()
		pass
	pass # Replace with function body.

func self_destroy():
	$smoke.emitting = false
	live = false
	$sprite.visible = false
	$anim_self_destruction.play("explode")
	
	#Desligar as colisões
	#monitoring = false
	#monitorable = false
	
	call_deferred("monitoring", false)
	call_deferred("monitorable", false)
	
	#yield = esperar
	yield($anim_self_destruction , "animation_finished")
	queue_free()
	pass