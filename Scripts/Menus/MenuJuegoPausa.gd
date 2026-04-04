extends CanvasLayer

@onready var sonido_button: Button = $ColorRect/CenterContainer/VBoxContainer/VBoxContainer/VolumenButton
@onready var continuar_button: Button = $ColorRect/CenterContainer/VBoxContainer/VBoxContainer/ContinuarButton

var cambiar : bool = false

func _ready() -> void:
	continuar_button.grab_focus()
	get_tree().paused = true
	is_playing_music()

func _on_continuar_button_pressed() -> void:
	get_tree().paused = false
	queue_free()
	
func _on_cargar_button_pressed() -> void:
	get_tree().paused = false
	LoadSavedGame.load_game()
	queue_free()

func _on_volumen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		SonidoGlobalMenus.pause_music()
	else:
		SonidoGlobalMenus.resume_music()
	
	is_playing_music()

func is_playing_music():
	if SonidoGlobalMenus.is_playing():
		sonido_button.text = " Musica: ON "
		sonido_button.button_pressed = false
	else:
		sonido_button.text = "Musica: OFF"
		sonido_button.button_pressed = true
		

func _on_salir_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/Menu_Principal.tscn")
	get_tree().paused = false
	queue_free()

func _on_cambiar_musica_pressed() -> void:
	if cambiar:
		SonidoGlobalMenus.change_music(false)
		cambiar = false
	else :
		SonidoGlobalMenus.change_music(true)
		cambiar = true
