extends Control

@onready var volver_button: Button = $VolverContainer/VolverButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volver_button.grab_focus()


func _on_volver_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/Menu_Opciones.tscn")
