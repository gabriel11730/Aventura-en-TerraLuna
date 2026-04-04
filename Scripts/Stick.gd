extends Area2D

class_name Stick

var distance : float
var direction: Vector2
var dead_zone: float = 30
@onready var stick_base: Sprite2D = $StickBase
@onready var stick_lever: Sprite2D = $StickLever
@onready var stick_radio = $StickCollision.shape.radius

var tocando : bool = false
var finger_index : int = -1 #Para saber que dedo presiona el Stick

func _ready() -> void:
	stick_lever.position = Vector2.ZERO

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			distance = global_position.distance_to(event.position)
			if distance < stick_radio:
				tocando = true
				finger_index = event.index
				_update_stick(event.position)
		elif event.index == finger_index:
			tocando = false
			finger_index = -1
			stick_lever.position = Vector2.ZERO
			direction = Vector2.ZERO
	
	elif event is InputEventScreenDrag:
		if tocando and event.index == finger_index:
			_update_stick(event.position)

func _update_stick(finger_position: Vector2):
	# Calculamos el vector desde el centro del joystick hasta el dedo
	var vector_to_finger = finger_position - global_position
	
	# Limitamos la longitud del vector al radio del stick (Clamping)
	if vector_to_finger.length() > stick_radio:
		vector_to_finger = vector_to_finger.normalized() * stick_radio
	
	# Aplicamos la posición. Usamos position local para ser más limpios, 
	stick_lever.global_position.x = global_position.x + vector_to_finger.x
	
	if abs(vector_to_finger.x) < dead_zone:
		direction = Vector2.ZERO
	else:
		# Calculamos la dirección normalizada (valor entre -1 y 1) para el personaje
		direction = vector_to_finger / stick_radio
