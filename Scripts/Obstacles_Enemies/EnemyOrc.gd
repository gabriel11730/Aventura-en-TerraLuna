extends Enemy 

func attack_ctrl():
	pass

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Personaje"):
		orc_attack_ctrl()

func orc_attack_ctrl():
	if permitir_movimiento:
		permitir_movimiento = false
		enemy_animation.play("attack")
