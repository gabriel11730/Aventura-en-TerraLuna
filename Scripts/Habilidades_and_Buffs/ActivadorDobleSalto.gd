extends Node2D

@onready var activador_conseguido: AudioStreamPlayer2D = $ActivadorConseguido
@onready var area_2d: Area2D = $Area2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Personaje"):
		area_2d.set_deferred("monitoring", false)
		GameState.desbloquear_doble_salto()
		activador_conseguido.play()
		visible = false

func _on_activador_conseguido_finished() -> void:
	queue_free()
