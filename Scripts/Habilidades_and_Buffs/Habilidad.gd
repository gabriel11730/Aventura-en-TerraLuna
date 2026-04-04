extends Node2D

@onready var sonido: AudioStreamPlayer2D = $HabilidadSonido
@onready var habilidad_sprite: Sprite2D = $HabilidadSprite

@export var Sprite : Texture2D
# una lista de seleccionables que permita definir la finalidad de la escena
# Un match dentro del on_body_enetered() que en funcion del tipo llame a un metodo u otro
enum Habilidad {DASH,SWORD,DOUBLE_JUMP,VIDA}
@export var Tipo : Habilidad = Habilidad.VIDA

# Investigar como limitar esta opcion a visible solo cuando se selecciona VIDA
@export var Cantidad_Vida : int = 1

var _interactuando : bool = false

func _ready() -> void:
	habilidad_sprite.texture = Sprite
	match Tipo:
		"DASH":
			habilidad_sprite.scale = Vector2(0.1,0.1)
		"SWORD":
			habilidad_sprite.scale = Vector2(0.1,0.1)
		"DOUBLE_JUMP":
			habilidad_sprite.scale = Vector2(0.4,0.4)
		"VIDA":
			habilidad_sprite.scale = Vector2(1.5,1.5)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if _interactuando or !body.is_in_group("Personaje"):
		return
	else:
		_interactuando = true
		match Tipo:
			"DASH":
				GameState.desbloquear_dash()
			"SWORD":
				GameState.desbloquear_sword()
				body.set_animations(true)
			"DOUBLE_JUMP":
				GameState.desbloquear_doble_salto()
			"VIDA":
				GameState.take_life(Cantidad_Vida)
		sonido.play()
		visible = false

func _on_sonido_finished() -> void:
	queue_free()
