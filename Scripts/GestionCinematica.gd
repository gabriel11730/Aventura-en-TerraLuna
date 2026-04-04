extends Area2D

@export var Cinematica: DatosHistoria


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Personaje"): # Seria bueno saber que forma es mejor
		body.set_physics_process(false)
		#Agregar efectos visuales
		
		comenzar_cinematica()
		body.set_physics_process(true)
		queue_free()

func comenzar_cinematica():
	if !Cinematica:
		print("No se han definido los datos de la cinematica")
		return
	var cinematica = load("res://Scenes/Cinematicas.tscn").instantiate()
	cinematica.story_texts = Cinematica.texts
	cinematica.story_images = Cinematica.background_texture
	
	get_tree().paused = true
	get_tree().root.add_child(cinematica)
	
	if !Cinematica.volver_al_mundo:
		get_tree().call_deferred("change_scene_to_file",Cinematica.ruta_siguiente_escena)
