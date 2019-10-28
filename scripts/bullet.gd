## -= IMPORTS =-
extends Area2D

## -= CONSTANTES =-
const MAX_DIST = 250
const VEL = 250

## -= VARIÁVEIS =-
var live = true
var dir = Vector2(0, -1) setget set_dir
#setget -> Quando VariávelMmodificada Chama uma Função
onready var init_pos = global_position
#global_position = posição dentro da cena, não do objeto

func _ready():
	pass

func _process(delta):
	# Se ainda tiver 'vivo', faz a verificação e movimento
	if live:
		if global_position.distance_to(init_pos) >= MAX_DIST:
			self_destroy()
		translate(dir * VEL * delta)
	pass

func _on_VisibilityNotifier2D_screen_exited():
	# Apagar da memória, de modo seguro
	queue_free()
	pass # Replace with function body.

# Mudar Direção, setget()
func set_dir(val):
	dir = val
	rotation = dir.angle()

# Quando Bala Atingir Parede
func _on_bullet_body_entered(body):
	if body.collision_layer == 4:
		self_destroy()
		pass
	pass

# Auto-Destruir, Após Animação
func self_destroy():
	var live = true
	
	# Parar Partículas e Fazer Desaparecer Bala
	$smoke.emitting = false
	$sprite.visible = false
	
	# Iniciar Animação
	$anim_self_destruction.play("explode")
	
	# Desligar as colisões do Objeto
	# monitoring = false
	# monitorable = false	
	call_deferred("monitoring", false)
	call_deferred("monitorable", false)
	
	# yield() -> esperar uma ação acontecer
	yield($anim_self_destruction , "animation_finished")
	queue_free()
	
	pass