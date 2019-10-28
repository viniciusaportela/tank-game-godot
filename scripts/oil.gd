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
		ref = overlaping[0]
		ref.get_parent().vel_mod = .5
		print(ref)
	# Senão, Apenas muda a velocidade para o Normal
	else:
		if ref:
			ref.get_parent().vel_mod = 1
		pass
	
	pass
