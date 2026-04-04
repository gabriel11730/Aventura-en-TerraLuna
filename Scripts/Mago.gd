extends Node2D

@onready var timer: Timer = $Timer
@onready var mago_animation: AnimationPlayer = $MagoAnimation

func _ready() -> void:
	mago_animation.play("Idle")

func _on_timer_timeout() -> void:
	mago_animation.play("out")


func _on_mago_animation_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"out":
			queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Personaje"):
		timer.start()
