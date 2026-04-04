extends Node2D

signal fin_minijuego

@export_file("*.tscn") var next_scene_path: String = ""

@onready var audio_portal: AudioStreamPlayer2D = $AudioPortal
@onready var transport_portal: AudioStreamPlayer = $TransportPortal

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Personaje"):
		# Una funcion deberia encargarse de esto!
		# Esto es una solucion sucia provisional
		transport_portal.playing = true 
		await get_tree().create_timer(0.20).timeout
		var pos_retorno = get_node_or_null("PosRetorno")
		if pos_retorno != null:
			body.position = pos_retorno.global_position
		else:
			fin_minijuego.emit()
func _on_audio_portal_finished() -> void:
	audio_portal.playing = true
