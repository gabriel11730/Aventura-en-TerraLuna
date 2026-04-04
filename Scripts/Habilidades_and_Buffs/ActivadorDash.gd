extends Node2D

@onready var activador_conseguido: AudioStreamPlayer2D = $HabilidadSonido

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Personaje"):
		GameState.desbloquear_dash()
		activador_conseguido.play()
		visible = false

func _on_activador_conseguido_finished() -> void:
	queue_free()
