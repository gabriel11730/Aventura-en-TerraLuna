extends Node2D

@onready var frase: Label = $Control/Frase
@onready var timer: Timer = $Timer

func _ready() -> void:
	frase.visible_ratio = 0.0

func _on_area_guardar_body_entered(body: Node2D) -> void:
	if body.is_in_group("Personaje"):
		LoadSavedGame.can_save.emit(true)
		var tween1 = create_tween()
		tween1.tween_property(frase,"visible_ratio",1.0,1.0)
		timer.start()

func _on_timer_timeout() -> void:
	var tween1 = create_tween()
	tween1.tween_property(frase,"visible_ratio",0.0,0.5)


func _on_area_guardar_body_exited(body: Node2D) -> void:
	if body.is_in_group("Personaje"):
		LoadSavedGame.can_save.emit(false)
