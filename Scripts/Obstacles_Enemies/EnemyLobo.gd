extends Enemy

@onready var attack_back: Area2D = $AttackBack

func _on_attack_back_body_entered(body: Node2D) -> void:
	if body.is_in_group("Personaje"):
		permitir_movimiento = false
		enemy_animation.play("attack")
