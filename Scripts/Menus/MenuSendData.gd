extends CanvasLayer

@onready var nombre_input: LineEdit = $ColorRect/CenterContainer/VBoxContainer/VBoxContainer/NombreInput
@onready var puntaje: Label = $ColorRect/CenterContainer/VBoxContainer/Puntaje

func _ready() -> void:
	nombre_input.grab_focus()
	puntaje.text = "Lo lograste en: " + _formatear_tiempo(TablaDePuntuaciones.get_puntaje_actual()) + "\n"
	get_tree().paused = true


func _on_send_data_button_pressed() -> void:
	if nombre_input.text != "":
		get_tree().paused = false
		TablaDePuntuaciones.enviardatos(nombre_input.text)
		get_tree().change_scene_to_file("res://Scenes/Menus/Menu_Minigames.tscn")
		queue_free()


func _on_salir_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/Menu_Principal.tscn")
	get_tree().paused = false
	queue_free()

func _formatear_tiempo(tiempo: float) -> String:
	var minutos = int(tiempo / 60)
	var segundos = int(tiempo) % 60
	var milisegundos = int((tiempo - int(tiempo)) * 100)
	return "%02d:%02d.%02d" % [minutos, segundos, milisegundos]
