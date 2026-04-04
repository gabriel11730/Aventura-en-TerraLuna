extends Enemy

var objetivo: Node2D = null

func _ready() -> void:
	rebotar_en_paredes = false
	evitar_caer = false
	speed = 0
	enemy_animation.play("idle")

func patrol_ctrl() -> void:
	pass

func _physics_process(delta: float) -> void:
	if objetivo != null and permitir_movimiento:
		_perseguir_objetivo()
	elif permitir_movimiento:
			speed = 0
			velocity.x = 0
			enemy_animation.play("idle")
	
	super._physics_process(delta)

func _perseguir_objetivo() -> void:
	# Calculamos distancia y dirección
	var dist_x = objetivo.global_position.x - global_position.x
	
	# Actualizamos la dirección SIEMPRE, incluso si estamos parados
	# Esto asegura que el RayCast de ataque siempre mire al jugador
	if dist_x > 0:
		direction = 1
		raycast.scale.x = 1
	elif dist_x < 0:
		direction = -1
		raycast.scale.x = -1

	# Lógica de movimiento
	if abs(dist_x) < 30: # Aumenté un poco el rango para darle espacio al ataque
		# Estamos muy cerca, frenamos pero seguimos mirándolo (por el código de arriba)
		speed = 0
		if enemy_animation.current_animation != "attack":
			enemy_animation.play("idle")
	else:
		# Estamos lejos, perseguimos
		speed = max_speed
		if enemy_animation.current_animation != "attack":
			enemy_animation.play("walk")

func _on_area_deteccion_body_entered(body: Node2D) -> void:
	# Verificamos si lo que entró es el jugador
	if body.is_in_group("Personaje"):
		objetivo = body # ¡Detectado! Empezamos a perseguir

func _on_area_deteccion_body_exited(body: Node2D) -> void:
	# Si el jugador sale del área, dejamos de perseguirlo
	if body == objetivo:
		objetivo = null
