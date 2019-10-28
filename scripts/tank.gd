# Executa tudo no proprio editor
tool

# Extende Funções de KinematicBody 2D
# Que extende de outras classes/libs também
extends KinematicBody2D

## -=CONSTANTES=-
# Velocidade de Rotação do Tanque
# Rotacionar Meio Circulo/Segundo (PI)
const ROT_VEL = PI

# Velocidade do Tanque em todas as direções
const MAX_SPEED = 100

## -=VARIÁVEIS GLOBAIS=-
var vel_mod = 1
var travel = 0
var ace = 0
onready var BULLET_TANK_GROUP = 'bullet-' + str(self)
# onready -> Variável que Executa Antes do _ready()

## -= PRE-LOADS =-
# Pre carregar um objeto/cena para poder usá-lo
var pre_bullet = preload('res://scenes/bullet.tscn')
var pre_track = preload('res://scenes/track.tscn')

## -= EXPORTS =-
# Export = Variável que Pode Editar no Inspetor
# Syntax: Export ( Tipo, Valores Possiveis )
export(int, "Red", "Blue", "Green", "Sand") var skin = 1 setget set_body

# Todas as Skins de Tanque Possíveis
var skins = [
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

# Chamada Quando for Preciso Desenhar/Redesenhar
func _draw():
	# Mudar Textura do Tanque
	$sprite.texture = load(skins[skin].body)
	$barrel/sprite.texture = load(skins[skin].barrel)
	pass

# _process -> Tempo Normal
# _physics_process -> Próprio Tempo Baseado na Física do Jogo

func _physics_process(delta):
	
	# Pra não executar movimento e tiro dentro do Editor
	if Engine.editor_hint:
		return
	
	## -= Variáveis Locais =-
	var rot = 0
	var dir = 0
#
	# Atirar
	if Input.is_action_just_pressed("ui_shoot"):
		# Pegar Grupo, Verificar se tem menos de 6 tiros na tela
		if get_tree().get_nodes_in_group(BULLET_TANK_GROUP).size() < 6:
			var bullet = pre_bullet.instance()

			# Posição dentro do jogo
			bullet.global_position = $barrel/muzzle.global_position

			# Mudar Variáveis de um Objeto
			# normalized() -> Ignorar Velocidade, só 1-0, só Direção
			bullet.dir = Vector2(cos($barrel.global_rotation), sin($barrel.global_rotation)).normalized()
			
			# Adiciona para o grupo do tanque
			bullet.add_to_group(BULLET_TANK_GROUP)

			# Pegar 'parent' - Pai
			# $"../" ou get_parent()
			get_parent().add_child(bullet)
			$barrel/anim.play("fire")
	
	# Rotacionar o Tanque
	if(Input.is_action_pressed("ui_right")):
		rot += 1
	if(Input.is_action_pressed("ui_left")):
		rot -= 1
	rotate(ROT_VEL * rot * delta)
	
	# Mover o Tanque
	if(Input.is_action_pressed("ui_up")):
		dir += 1
		pass
	if(Input.is_action_pressed("ui_down")):
		dir -= 1
		pass
	ace = lerp(ace, MAX_SPEED * dir , 0.03)
	var move = move_and_slide(Vector2(cos(rotation), sin(rotation)) * ace * vel_mod)
	
	# Calcular Caminho, para criar Trilhas no Chão
	travel += move.length() * delta
	
	if travel > $sprite.texture.get_size().y:
		var track = pre_track.instance()
		track.global_position = global_position - Vector2(cos(rotation), sin(rotation)).normalized() * 5
		track.rotation = rotation
		track.z_index = z_index - 1
		get_parent().add_child(track)
		travel = 0
	
	# Fazer Mira Olhar para Posição do Mouse
	$barrel.look_at(get_global_mouse_position())
	pass

# Função executada toda vez que a skin atual for atualizada
func set_body(val):
	skin = val
	
	# Se estiver no modo editor
	if Engine.editor_hint:
		# Executa _draw()
		update()
	
	pass