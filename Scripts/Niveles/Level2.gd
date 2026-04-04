extends Node2D

@onready var personaje: Personaje = $MapsLayers/Personaje

func _ready() -> void:
	GameState.is_history_level = true
	GameState.ruta_level_actual = get_tree().current_scene.scene_file_path
	GameState.desbloquear_sword()
	if GameState.sword_estado():
		personaje.set_animations(true)
