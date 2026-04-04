extends Node2D
class_name SaverLoader

@warning_ignore("unused_signal")
signal can_save(valor: bool)

func save_game():
	#print("LoadSavedGame ha respondido a interfaz")
	var saved_game := SaveGame.new()
	
	# save the path to the currently loaded level
	saved_game.level_path = get_tree().current_scene.scene_file_path
	
	var _Personaje = get_tree().get_first_node_in_group("Personaje")
	# store data for Jugador 
	saved_game.position_personaje = _Personaje.global_position
	saved_game.life_personaje = GameState.get_life()
	saved_game.coins_collected_personaje = GameState.get_coins()
	saved_game.dash_estado = GameState.dash_estado()
	saved_game.doble_salto_estado = GameState.doble_salto_estado()
	saved_game.sword_estado = GameState.sword_estado()
	saved_game.antorcha_estado = GameState.antorcha_estado()

	# collect all dynamic game elements	
	var saved_data:Array[SavedData] = []
	get_tree().call_group("GameEvents", "on_save_game", saved_data)
	# store them in the savegame
	saved_game.saved_data = saved_data
	# write the savegame to disk
	ResourceSaver.save(saved_game, "user://savegame.tres")
	
func load_game():
	if not ResourceLoader.exists("user://savegame.tres"):
		print("No hay partidas guardadas")
		return
	
	var saved_game:SaveGame = load("user://savegame.tres") as SaveGame
	#await _Level.load_level_async(saved_game.level_path)
	var ruta_actual = get_tree().current_scene.scene_file_path
	
	if ruta_actual != saved_game.level_path:
		get_tree().change_scene_to_file(saved_game.level_path)
		await get_tree().tree_changed
	
	var attemps: int = 0
	while get_tree().current_scene == null and attemps < 10:
		attemps += 1
		await get_tree().process_frame
		#print("intento:", attemps)
		
	#print("Ruta esperada: ", saved_game.level_path)
	#print("Ruta actual: ", get_tree().current_scene.name)

	get_tree().call_group("GameEvents", "on_before_load_game")
	
	var _Personaje = get_tree().get_first_node_in_group("Personaje")
	#var nodos_en_grupo = get_tree().get_nodes_in_group("Personaje")
	#print("Nodos encontrados en el grupo 'Personaje': ", nodos_en_grupo.size())
	
	if _Personaje:
		_Personaje.global_position = saved_game.position_personaje
		GameState.life_personaje = min(saved_game.life_personaje, GameState.life_max)
		GameState.coins = saved_game.coins_collected_personaje
		GameState.dash_desbloqueado = saved_game.dash_estado
		GameState.doble_salto_desbloqueado = saved_game.doble_salto_estado
		GameState.sword_desbloqueado = saved_game.sword_estado
		GameState.antorcha_desbloqueada = saved_game.antorcha_estado
	else:
		print("Error: no se encontro Jugador en la escena seleccionada")
		
	var current_level_root = get_tree().current_scene
	
	for item in saved_game.saved_data:
		# load the scene of the saved item and create a new instance
		var scene := load(item.scene_path) as PackedScene
		var restored_node = scene.instantiate()
		# add it to the world root
		current_level_root.add_child(restored_node)
		# and run any custom load logic
		if restored_node.has_method("on_load_game"):
			restored_node.on_load_game(item)
	
	GameState.get_coins()
	GameState.get_life()
	GameState.sword_estado()
	if get_tree().current_scene.name == "Level2":
		GameState.antorcha_estado()
		
	else:
		GameState.antorcha_desbloqueada = false
		GameState.antorcha_estado()
