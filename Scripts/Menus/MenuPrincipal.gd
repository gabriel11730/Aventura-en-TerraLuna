extends Control

@export var Datos_Historia: Array[DatosHistoria]
@onready var jugar_button: Button = $ButtonContainer/JugarButton

func _ready() -> void:
	jugar_button.grab_focus()

func _on_jugar_button_pressed() -> void:
	comenzar_cinematica(0)


func _on_opciones_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/Menu_Opciones.tscn")


func _on_salir_button_pressed() -> void:
	get_tree().quit()

func _on_mini_juegos_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/Menu_Minigames.tscn")

func _on_controls_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/Menu_Controles.tscn")

func comenzar_cinematica(valor: int):
	if !Datos_Historia:
		print("No se han definido los datos de la cinematica")
		return
	var cinematica = load("res://Scenes/Cinematicas.tscn").instantiate()
	cinematica.story_texts = Datos_Historia[valor].texts
	cinematica.story_images = Datos_Historia[valor].background_texture
	
	get_tree().paused = true
	get_tree().root.add_child(cinematica)
	
	if !Datos_Historia[valor].volver_al_mundo:
		get_tree().call_deferred("change_scene_to_file",Datos_Historia[valor].ruta_siguiente_escena)
