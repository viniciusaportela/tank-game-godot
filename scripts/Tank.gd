#Executa tudo no proprio editor
tool
extends KinematicBody2D

# Rotacionar Meio Circulo/Segundo
const ROT_VEL = PI
#Velocidadde do Tanque em todas as direções
const MAX_SPEED = 100

var travel = 0

var ace = 0

#onready = variável so inicializada quando script tiver pronto
#Seria o mesmo de colocar em _ready
onready var BULLET_TANK_GROUP = 'bullet-' + str(self)

#Pre carregar um objeto/cena para poder usá-lo
var pre_bullet = preload('res://scenes/bullet.tscn')
var pre_track = preload('res://scenes/track.tscn')

#Export = Pode editar no Inspetor
#Export ( Tipo, Valores Possiveis )
export(int, "Red", "Blue", "Green", "Sand") var skin = 1 setget set_body

var bodies = [
	{
		'body': 'res://sprites/tankBody_red.png',
		'barrel': 'res://sprites/tankRed_barrel2_outline.png'
	},
	
	{
		'body': 'res://sprites/tankBody_blue.png',
		'barrel': 'res://sprites/tankBlue_barrel2_outline.png'
	},
	
	{
		'body': 'res://sprites/tankBody_green.png',
		'barrel': 'res://sprites/tankGreen_barrel2_outline.png'
	},
	
	{
		'body': 'res://sprites/tankBody_sand.png',
		'barrel': 'res://sprites/tankSand_barrel2_outline.png'
	}
]

func _ready():
	pass

#Chamada quando for preciso desenhar/redesenhar
func _draw():
	$sprite.texture = load(bodies[skin].body)
	$barrel/sprite.texture = load(bodies[skin].barrel)
	pass

#_process = tempo normal
#_physics_process = tem seu tempo próprio para física

func _physics_process(delta):
	
	#Pra não executar movimento e tiro
	if Engine.editor_hint:
		return
	
#	var dir_x = 0
#	var dir_y = 0
#
#	# Move the tank
#	if(Input.is_action_pressed("ui_right")):
#		dir_x += 1
#	if(Input.is_action_pressed("ui_left")):
#		dir_x -= 1
#	if(Input.is_action_pressed("ui_up")):
#		dir_y-=1
#	if(Input.is_action_pressed("ui_down")):
#		dir_y+=1
#
	#Atirar
	if Input.is_action_just_pressed("ui_shoot"):
		#Pegar Grupo
		if get_tree().get_nodes_in_group(BULLET_TANK_GROUP).size() < 6:
			var bullet = pre_bullet.instance()

			#Posição dentro do jogo
			bullet.global_position = $barrel/muzzle.global_position

			#change bullet variables
			#normalized -> pra ignorar velocidade, só 1-0
			bullet.dir = Vector2(cos($barrel.global_rotation), sin($barrel.global_rotation)).normalized()

			bullet.add_to_group(BULLET_TANK_GROUP)

			#Pegar 'parent' - Pai
			# $"../" ou get_parent()
			get_parent().add_child(bullet)
			$barrel/anim.play("fire")
#
#	#Olhar para o mouse
#	look_at(get_global_mouse_position())
#
#	#translate -> move independente da física
#	#move_and_slide -> move e escorrega na parede
#	move_and_slide(Vector2(dir_x, dir_y) * speed)

	var rot = 0
	var dir = 0
	
	if(Input.is_action_pressed("ui_right")):
		rot += 1
	if(Input.is_action_pressed("ui_left")):
		rot -= 1
	
	if(Input.is_action_pressed("ui_up")):
		dir += 1
		pass
	if(Input.is_action_pressed("ui_down")):
		dir -= 1
		pass

	rotate(ROT_VEL * rot * delta)
	
	ace = lerp(ace, MAX_SPEED * dir , 0.03)
	
	var move = move_and_slide(Vector2(cos(rotation), sin(rotation)) * ace)
	
	travel += move.length()
	
	if travel > 3000:
		var track = pre_track.instance()
		track.global_position = global_position
		track.rotation = rotation
		track.z_index = z_index - 1
		get_parent().add_child(track)
		travel = 0
		print('track')
	
	$barrel.look_at(get_global_mouse_position())
	pass
	
func set_body(val):
	skin = val
	
	#Se estiver no modo editor
	if Engine.editor_hint:
		#Executa Draw
		update()
	
	pass