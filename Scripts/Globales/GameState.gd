extends Node

signal actualizar_vida(nueva_vida: int)
signal recibir_damage
signal personaje_muerto
signal actualizar_coins(coins: int)
signal actualizar_antorcha(estado: bool)
signal set_animations(estado_sword: bool)

#Variables vida
var life_max: int = 5
var life_personaje: int = 5
var inmunity_temporal: bool = false
#Habilidades
var doble_salto_desbloqueado: bool = false 
var dash_desbloqueado: bool = false
var sword_desbloqueado: bool = false
#Antorcha
var antorcha_desbloqueada: bool = false
#Monedas
var coins: int = 0

#Ruta actual y seleccion de Screen GamerOver
var ruta_level_actual: String = ""
var is_history_level: bool

func game_over():
	if is_history_level:
		get_tree().change_scene_to_file("res://Scenes/Menus/GameOver.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/Menus/GameOverMiniGames.tscn")

#Aqui desbloqueo las habilidades
func desbloquear_doble_salto()->void:
	doble_salto_desbloqueado = true
	print("¡Doble Salto Desbloqueado!")

func doble_salto_estado()->bool:
	return doble_salto_desbloqueado

func desbloquear_dash()->void:
	dash_desbloqueado = true
	print("¡Dash Desbloqueado!")

func dash_estado()->bool:
	return dash_desbloqueado

func desbloquear_sword()->void:
	sword_desbloqueado = true
	set_animations.emit(sword_desbloqueado)

func sword_estado()->bool:
	set_animations.emit(sword_desbloqueado)
	return sword_desbloqueado

func desbloquear_antorcha()->void:
	antorcha_desbloqueada = true
	antorcha_estado()

func antorcha_estado()->bool:
	actualizar_antorcha.emit(antorcha_desbloqueada)
	return antorcha_desbloqueada

#Controlar variable life_personaje
func take_damage(damage: int):
	if not inmunity_temporal:
		inmunity_temporal = true
		if life_personaje > damage:
			life_personaje -= damage
			recibir_damage.emit()
		elif life_personaje <= damage:
			life_personaje = 0
			personaje_muerto.emit()
		actualizar_vida.emit(life_personaje)

func set_inmunity():
	inmunity_temporal = false

func take_life(life: int):
	if life_personaje + life > life_max:
		life_personaje = life_max
	else:
		life_personaje += life
	actualizar_vida.emit(life_personaje)

func get_life():
	actualizar_vida.emit(life_personaje)
	return life_personaje

#Controlar variable coins
func sumar_monedas():
	coins += 1
	actualizar_coins.emit(coins)

func get_coins():
	actualizar_coins.emit(coins)
	return coins

func reset_game():
	#Todo debe quedar limpio, para una nueva partida.
	life_personaje = life_max
	doble_salto_desbloqueado = false 
	dash_desbloqueado = false
	sword_desbloqueado = false
	coins = 0
	antorcha_desbloqueada = false

func eliminar_nodos_en_grupo(nombre_grupo: String) -> void:
	# 1. Almacenamos todos los nodos del grupo en un Array
	var nodos_a_eliminar = get_tree().get_nodes_in_group(nombre_grupo)
	
	# 2. Verificamos si hay nodos (opcional, pero buena práctica para debug)
	if nodos_a_eliminar.is_empty():
		print("No se encontraron nodos en el grupo: ", nombre_grupo)
		return

	print("Eliminando ", nodos_a_eliminar.size(), " nodos del grupo: ", nombre_grupo)

	# 3. Recorremos el array y los eliminamos uno por uno
	for nodo in nodos_a_eliminar:
		# Verificamos que el nodo sea válido antes de borrarlo (seguridad extra)
		if is_instance_valid(nodo):
			nodo.queue_free()
