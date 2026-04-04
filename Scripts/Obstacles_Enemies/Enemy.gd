extends CharacterBody2D

class_name Enemy

@onready var enemy_collision: CollisionShape2D = $EnemyCollision
@onready var raycast: Marker2D = $Raycast
@onready var is_precipice: RayCast2D = $Raycast/IsPrecipice
@onready var is_enemy: RayCast2D = $Raycast/IsEnemy
@onready var attack: RayCast2D = $Raycast/Attack
@onready var enemy_sprite: Sprite2D = $EnemySprite
@onready var attack_sound: AudioStreamPlayer2D = $AttackSound
@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var dead_sound: AudioStreamPlayer2D = $DeadSound
@onready var enemy_animation: AnimationPlayer = $EnemyAnimation

@export_range(1,10) var vida: int #Increible
@export var min_speed: int = 40
@export var max_speed: int = 85
@export var evitar_caer: bool = true
@export var rebotar_en_paredes: bool = true

var damage: int = 1
var permitir_movimiento: bool = true
var direction: int = 1
var speed: int

func on_save_game(saved_data:Array[SavedData]):
	var my_data = SavedData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path

	saved_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()
	
func on_load_game(saved_data:SavedData):
	global_position = saved_data.position
	
func _ready() -> void:
	enemy_animation.play("walk")

func _physics_process(delta: float) -> void:
	patrol_ctrl()
	attack_ctrl()
	
	if permitir_movimiento:
		if not is_on_floor(): #Aplicamos Gravedad
			velocity += get_gravity() * delta
		if direction > 0: # Volteamos Sprites a Conveniencia
			enemy_sprite.flip_h = false
		else:
			enemy_sprite.flip_h = true
		
		var _hay_precipicio = not is_precipice.is_colliding() 
		if (rebotar_en_paredes and is_on_wall()) or (evitar_caer and _hay_precipicio):
			direction *= -1
			raycast.scale.x *= -1

		velocity.x = direction * speed
		move_and_slide()

func patrol_ctrl():
	if permitir_movimiento:
		if is_enemy.is_colliding():
			if get_node("Raycast/IsEnemy").get_collider().is_in_group("Personaje"):
				enemy_animation.play("run")
				speed = max_speed
			else:
				enemy_animation.play("walk")
				speed = min_speed
		else:
			enemy_animation.play("walk")
			speed = min_speed
		
func attack_ctrl():
	if permitir_movimiento:
		if attack.is_colliding():
			if get_node("Raycast/Attack").get_collider().is_in_group("Personaje"):
				permitir_movimiento = false
				enemy_animation.play("attack")

func take_damage(_damage: int):
	#match permitir_movimiento:
		#true:
			if vida > _damage:
				enemy_animation.play("take_damage")
				vida -= _damage
			else:
				enemy_animation.play("die")

func _on_enemy_animation_started(anim_name: StringName) -> void:
	match anim_name:
		"take_damage":	
			permitir_movimiento = false
			hit_sound.play()
		"attack":
			attack_sound.play()
			GameState.take_damage(damage)
		"die":
			permitir_movimiento = false
			enemy_collision.set_deferred("disabled", true)
			dead_sound.play()

func _on_enemy_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"take_damage":
			permitir_movimiento = true
		"attack":
			permitir_movimiento = true
			enemy_animation.play("walk")
		"die":
			queue_free()
