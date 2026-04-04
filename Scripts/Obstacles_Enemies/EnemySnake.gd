extends Enemy

func patrol_ctrl():
	if permitir_movimiento:
		enemy_animation.play("walk")
		speed = min_speed

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Personaje"):
		snake_attack_ctrl()

func snake_attack_ctrl():
	if permitir_movimiento:
		permitir_movimiento = false
		enemy_animation.play("attack")

func attack_ctrl():
	pass
