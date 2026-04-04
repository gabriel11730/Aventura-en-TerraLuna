extends CharacterBody2D

class_name Personaje

#Referencia al Stick
@export var Stick_Controller : Stick
@export var damage: int = 1
@export var bounce_damage: int = 1

#Variables de animated sprite
@export var animations_desarmado: SpriteFrames
@export var animations_armado: SpriteFrames

@onready var personaje_animated: AnimatedSprite2D = $PersonajeAnimated
@onready var attack_area: Area2D = $AttackArea
@onready var interfaz: CanvasLayer = $Interfaz
#Sonidos
@onready var dead_sound: AudioStreamPlayer2D = $DeadSound
@onready var hit_sound: AudioStreamPlayer2D = $HitSound
#dash_particles
@onready var dash_particle: GPUParticles2D = $dash_particle
@onready var dash_sound: AudioStreamPlayer2D = $dash_sound

#antorcha
@onready var antorcha: PointLight2D = $Antorcha

#Basic Variables
var speed = 130.0 #150.0
var jump_velocity = -345.0 #-400
var permitir_movimiento: bool
var is_alive: bool
#Variables de Habilidades
var dash_speed = 550 #600
var dash_direction: int = -1
var is_dashing: bool = false
var is_dashing_on_air: bool = false
var is_doble_jump: bool = false
var is_attacking: bool = false
var is_attacking_on_air: bool = false

#Teclas
var izquierda : String = "ui_left"
var derecha : String = "ui_right"
var saltar : String = "saltar"
var atacar : String = "Atacar"
var dash : String = "dash"

func _ready() -> void:
	permitir_movimiento = true
	is_alive = true
	set_animations(GameState.sword_estado())
	GameState.set_animations.connect(set_animations)
	GameState.recibir_damage.connect(take_damage)
	GameState.personaje_muerto.connect(morir)
	GameState.actualizar_antorcha.connect(_activar_antorcha)
	

func jump() -> void:
	if permitir_movimiento:
		velocity.y = jump_velocity
		is_doble_jump = false

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed(saltar) and is_on_floor():
		jump()
	
	#Doble Salto
	if GameState.doble_salto_estado() and not is_on_floor() and Input.is_action_just_pressed(saltar):
		if !is_doble_jump and permitir_movimiento:
			is_doble_jump = true
			personaje_animated.play("Up")
			velocity.y = jump_velocity
	#Atacar
	if GameState.sword_estado() and Input.is_action_just_pressed(atacar) and permitir_movimiento:
		if is_attacking or is_attacking_on_air:
			return
		velocity = Vector2.ZERO
		is_attacking = true
		is_attacking_on_air = true
		permitir_movimiento = false
		#Actualizar AttackArea
		if personaje_animated.flip_h:
			attack_area.position.x = 25
		if !personaje_animated.flip_h:
			attack_area.position.x = -25
		attack_area.get_child(0).disabled = false #Equivalente a una referencia a CollisionShape
		personaje_animated.play("Atacar")
		await get_tree().create_timer(0.25).timeout
		attack_area.get_child(0).disabled = true #Equivalente a una referencia a CollisionShape
		is_attacking = false
		permitir_movimiento = true

func _physics_process(delta: float) -> void:
	animations()
	#Ambos IF antes estaban dentro del condicional de 'if permitir movimiento:'
	if is_on_floor():
		is_attacking_on_air = false
		is_dashing_on_air = false
		is_doble_jump = false # Linea nueva
	#Se agrego is_dashing para evitar que la gravedad afecte a la habilidad
	if not is_on_floor() and not is_dashing:
		velocity += get_gravity() * delta
			
	if permitir_movimiento:
		var input_axis := Input.get_axis(izquierda, derecha)
		
		if Stick_Controller and Stick_Controller.direction.x != 0:
			input_axis = Stick_Controller.direction.x
		
		if input_axis:
			velocity.x = input_axis * speed
			if input_axis > 0: # Moviéndose a la izquierda
				personaje_animated.flip_h = true
				dash_direction = 1
			elif input_axis < 0: # Moviéndose a la derecha
				personaje_animated.flip_h = false
				dash_direction = -1
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

	#Impulso Dash
	if GameState.dash_estado() and Input.is_action_just_pressed(dash) and permitir_movimiento:
		if is_dashing or is_dashing_on_air:
			return
		permitir_movimiento = false
		is_dashing_on_air = true
		is_dashing = true
		dash_sound.play()
		velocity.x = dash_direction * dash_speed
		velocity.y = 0
		dash_particle.emitting = true
		personaje_animated.play("Up")
		await get_tree().create_timer(0.2).timeout
		is_dashing = false
		dash_particle.emitting = false
		permitir_movimiento = true
	
	move_and_slide()

func set_animations(espada_desbloqueada: bool):
	if espada_desbloqueada:
		personaje_animated.sprite_frames = animations_armado
	else:
		personaje_animated.sprite_frames = animations_desarmado

func animations():
	if is_alive and permitir_movimiento:
		if not is_on_floor():
			if velocity.y < 0:
				personaje_animated.play("Up")
			elif velocity.y > 0:
				personaje_animated.play("Down")
			return
			
		if velocity.x:
			personaje_animated.play("Run")
		else:
			personaje_animated.play("Idle")

func take_damage():
	permitir_movimiento = false
	velocity = Vector2.ZERO
	hit_sound.play()
	personaje_animated.modulate = Color("ff0000d5")
	var tween = create_tween()
	var tweenOffset = create_tween()
	tween.tween_property(personaje_animated, "modulate", Color(1, 1, 1, 1), 0.3)
	tweenOffset.tween_property(personaje_animated, "offset", Vector2(-5,-10), 0.05)
	tweenOffset.tween_property(personaje_animated, "offset", Vector2(5,-10), 0.10)
	tweenOffset.tween_property(personaje_animated, "offset", Vector2(0,-10), 0.05)
	GameState.set_inmunity()
	await  tweenOffset.finished
	permitir_movimiento = true

func morir():
	permitir_movimiento = false
	velocity = Vector2.ZERO
	dead_sound.play()
	personaje_animated.play("Die_End")
	is_alive = false
	await get_tree().create_timer(2).timeout
	GameState.set_inmunity()
	interfaz.GameOver()

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.take_damage(damage) 
		#Puedo tener una variable global que modifique el daño que hace el jugador

func _on_attack_bounce_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.take_damage(bounce_damage)
		jump()

func _activar_antorcha(estado: bool):
	antorcha.enabled = estado
