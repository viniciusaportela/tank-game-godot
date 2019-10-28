extends Area2D

## -= VARIÁVEIS =-
var ref
# Referência para o Tanque

func _ready():
	pass 

func _process(delta):
	# Checa por Todas as Areas que Estão Sobrepondo
	var overlaping = get_overlapping_areas()
	
	# Se tiver sobrepondo, Adiciona
	# Diminui a velocidade também
	if overlaping:
		for item in overlaping:
			print(item)
			if item.get_parent().has_method('slow_down'):
				item.get_parent().slow_down()