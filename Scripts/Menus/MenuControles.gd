extends Control

@onready var volver_button: Button = $ButtonContainer2/VolverButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volver_button.grab_focus()

func _on_mando_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/Controls/Menu_Mando.tscn")


func _on_teclado_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/Controls/Menu_Teclado.tscn")


func _on_pantalla_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/Controls/Menu_Pantalla.tscn")


func _on_volver_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/Menu_Principal.tscn")
