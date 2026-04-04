extends Control

@onready var reset_button: Button = $ButtonContainer/ResetButton

var tween = create_tween()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_button.grab_focus()
	SonidoGlobalMenus.play_game_over_sound()
	modulate = Color("ffffff4f")
	mostrar_gameover()

func mostrar_gameover():
	tween.tween_property($".", "modulate", Color(1, 1, 1, 1), 2)

func _on_reset_button_pressed() -> void:
	stop_music_game_over()
	GameState.reset_game()
	get_tree().change_scene_to_file(GameState.ruta_level_actual)

func _on_cargar_button_pressed() -> void:
	stop_music_game_over()
	LoadSavedGame.load_game()

func _on_back_button_pressed() -> void:
	stop_music_game_over()
	GameState.reset_game()
	get_tree().change_scene_to_file("res://Scenes/Menus/Menu_Principal.tscn")
	
func stop_music_game_over():
	SonidoGlobalMenus.stop_game_over_music()
