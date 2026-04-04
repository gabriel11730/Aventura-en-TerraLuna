extends Node2D

@export var set_animations: SpriteFrames
@export var texto_frase: String = ""
@export var orientacion: bool


@onready var contenedor_frase: Control = $ContenedorFrase
@onready var npc_animation: AnimatedSprite2D = $NPC_Animation
@onready var frase: Label = $ContenedorFrase/Frase
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frase.visible_ratio = 0.0
	frase.text = texto_frase
	npc_animation.sprite_frames = set_animations
	npc_animation.play("Idle")
	npc_animation.flip_h = orientacion

func _on_npc_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Personaje"):
		var tween1 = create_tween()
		tween1.tween_property(frase,"visible_ratio",1.0,1.0)
		timer.start()

func _on_timer_timeout() -> void:
	var tween1 = create_tween()
	tween1.tween_property(frase,"visible_ratio",0.0,0.5)
