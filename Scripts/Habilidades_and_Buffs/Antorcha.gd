extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var antorcha_obtenida: AudioStreamPlayer2D = $AntorchaObtenida
@onready var area_2d: Area2D = $Area2D



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Personaje"):
		GameState.desbloquear_antorcha()
		antorcha_obtenida.play()
		area_2d.set_deferred("disabled", true)
		$".".hide()


func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
