extends Control

@onready var cambiar_musica: Button = $ButtonContainer/CambiarMusica
@onready var musica_button: Button = $ButtonContainer/MusicaButton

var cambiar : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cambiar_musica.grab_focus()
	is_playing_music()


func _on_sonido_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		SonidoGlobalMenus.pause_music()
	else:
		SonidoGlobalMenus.resume_music()
	
	is_playing_music()

func is_playing_music():
	if SonidoGlobalMenus.is_playing():
		musica_button.text = " Musica: ON "
		musica_button.button_pressed = false
	else:
		musica_button.text = "Musica: OFF"
		musica_button.button_pressed = true
		

func _on_creditos_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/Menu_Creditos.tscn")


func _on_volver_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/Menu_Principal.tscn")


func _on_cambiar_musica_pressed() -> void:
	if cambiar:
		SonidoGlobalMenus.change_music(false)
		cambiar = false

	else :
		SonidoGlobalMenus.change_music(true)
		cambiar = true
