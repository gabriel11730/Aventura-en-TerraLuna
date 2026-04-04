extends Node2D


@onready var portal: Node2D = $Portales/Portal
@onready var contenedor_parallax: Node2D = $Parallax/ContenedorParallax
@onready var set_otoño: Node2D = $Parallax/ContenedorParallax/SetOtoño
@onready var set_invierno: Node2D = $Parallax/ContenedorParallax/SetInvierno
@onready var altura_parallax_1: Area2D = $Parallax/AlturaParallax1
@onready var altura_parallax_2: Area2D = $Parallax/AlturaParallax2
@onready var personaje: Personaje = %Personaje
@onready var canvas_modulate: CanvasModulate = $Lightning/CanvasModulate

var tiempo_cambio_estacion: int = 4

func _ready() -> void:
	GameState.is_history_level = true
	GameState.ruta_level_actual = get_tree().current_scene.scene_file_path
	GameState.reset_game()

func _on_altura_parallax_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("Personaje"):
		var tween = create_tween()
		tween.tween_property(contenedor_parallax, "global_position", Vector2(0,-190) ,1)
		if tween.finished:
			altura_parallax_1.queue_free()

func _on_altura_parallax_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("Personaje"):
		var tween = create_tween()
		tween.tween_property(contenedor_parallax, "global_position", Vector2(0,-140) ,0.6)
		#if tween.finished:
			#altura_parallax_2.queue_free()

func _on_altura_parallax_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("Personaje"):
		var tween = create_tween()
		tween.tween_property(contenedor_parallax, "global_position", Vector2(0,-170) ,0.8)


## Gestionar cambio de estacion
func cambiar_a_otoño() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUINT) # Tipo de movimiento suave
	#tween.set_ease(Tween.EASE_IN_OUT) # Aceleración suave al inicio y fin
	tween.tween_property(set_otoño, "modulate", Color("ffffff00"),tiempo_cambio_estacion)
	tween.set_parallel()
	tween.tween_property(set_invierno, "modulate", Color("ffffff"),tiempo_cambio_estacion)

func cambiar_a_invierno() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	#tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(set_otoño, "modulate:a", 1,tiempo_cambio_estacion)
	tween.set_parallel()
	tween.tween_property(set_invierno, "modulate:a", 0,tiempo_cambio_estacion)

func _on_cambio_textura_parallax_body_entered(body: Node2D) -> void:
	if body.is_in_group("Personaje"):
		cambiar_a_otoño()

func _on_cambio_textura_parallax_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("Personaje"):
		cambiar_a_invierno()


func _on_eliminar_gestores_body_entered(body: Node2D) -> void:
	if body.is_in_group("Personaje"):
		GameState.eliminar_nodos_en_grupo("Eliminar")


func _on_ajustar_iluminacion_body_entered(body: Node2D) -> void:
	if body.is_in_group("Personaje"):
		var tween_iluminacion = create_tween()
		tween_iluminacion.tween_property(canvas_modulate,"color", Color("9e9e9e"), 0.5)
