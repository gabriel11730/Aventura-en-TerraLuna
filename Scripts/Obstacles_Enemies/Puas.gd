extends Area2D

@onready var pos_retorno: Marker2D = $PosRetorno
@export var damage: int = 1

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Personaje"):
		GameState.take_damage(damage)
		# Una funcion deberia encargarse de esto!
		# Esto es una solucion sucia provisional
		await get_tree().create_timer(0.20).timeout
		body.position = pos_retorno.global_position
	
