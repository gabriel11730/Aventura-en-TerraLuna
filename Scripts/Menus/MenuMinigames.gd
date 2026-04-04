extends Control

@export var Datos_Historia: Array[DatosHistoria]

@onready var volver: Button = $Options/Volver

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volver.grab_focus()


func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Niveles/MiniGame1.tscn")


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Niveles/MiniGame2.tscn")

func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Niveles/MiniGame3.tscn")


func _on_instrucciones_pressed() -> void:
	comenzar_cinematica(0)


func _on_mejores_puntuaciones_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/Menu_Clasificaciones.tscn")


func _on_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/Menu_Principal.tscn")
	
	
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
