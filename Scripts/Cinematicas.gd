extends CanvasLayer

# --- Nodos ---
@onready var background_image: TextureRect = $BackgroundImage 
@onready var control_labels: Control = $Panel/MarginContainer/LabelsControl 
@onready var label_container: VBoxContainer = $Panel/MarginContainer/LabelsControl/LabelContainer 

@onready var label_timer: Timer = $LabelTimer 
@onready var saltar_button: Button = $ControlButtons/SaltarButton 
@onready var continuar_button: Button = $ControlButtons/ContinuarButton 

# Aquí se cargará la información específica para esta cinemática.
var story_images: Array[Texture2D] = []
var story_texts: Array[String] = []

# --- Variables de Estado ---
var all_story_labels: Array[Label] = []
var current_label_index = -1 
var current_label_full_text = ""
var current_character_visible_count = 0

var move_speed = 10.0 # Píxeles por segundo
var target_y_position = -170.0 # Posición objetivo del fondo

func _ready():
	saltar_button.grab_focus()
# 1. Configura el fondo si hay imágenes disponibles
	if not story_images.is_empty():
		background_image.texture = story_images[0] # Asume que la primera imagen es el fondo inicial
	
# 2. Crea los nodos Label dinámicamente a partir del array de textos
	_setup_labels()

# 3. Conexiones y estado inicial
	process_mode = Node.PROCESS_MODE_ALWAYS
	label_timer.timeout.connect(_on_timer_labels_timeout)
	continuar_button.visible = false
	saltar_button.visible = true
	comenzar_historia()

func _unhandled_input(_event: InputEvent) -> void:
	# Permite saltar toda la cinemática
	if Input.is_action_just_pressed("ui_accept"):
		_on_saltar_button_pressed()

func _process(delta) -> void:
	
	# Movimiento de fondo
	if background_image.position.y > target_y_position:
		background_image.position.y -= move_speed * delta
	if background_image.position.y < target_y_position:
		background_image.position.y = target_y_position
# Crea y configura los nodos Label
func _setup_labels():
# Limpia cualquier Label previo si existiera
	for child in label_container.get_children():
		child.queue_free()
			
		all_story_labels.clear() # Limpia el array de referencias

	for text_line in story_texts:
		var new_label = Label.new()
		new_label.text = text_line
		new_label.visible = false # Oculto hasta que se active
# --- Configuración Visual del Label ---
		new_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		new_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
		new_label.theme_type_variation = &"HeaderSmall"
		label_container.add_child(new_label) # Agrega al contenedor
		all_story_labels.append(new_label) # Guarda la referencia para el control de la historia

func comenzar_historia():
	# Oculta el Label anterior (si existe)
	if current_label_index >= 0 and current_label_index < all_story_labels.size():
		all_story_labels[current_label_index].visible = false

	# Avanza al siguiente Label
	current_label_index += 1

	if current_label_index < all_story_labels.size():
		var next_label = all_story_labels[current_label_index]

		next_label.visible = true
		# Prepara el texto para el efecto de máquina de escribir
		current_label_full_text = next_label.text
		next_label.text = "" # Texto en blanco para iniciar la escritura
		next_label.visible_characters = 0
		current_character_visible_count = 0
		label_timer.start()
		
	else:
		print("Cinemática terminada")
		_exit_cinematic()

func _exit_cinematic():
	#reanudar la escena del juego
	get_tree().paused = false

	#Eliminar esta escena de la cinemática (limpieza)
	queue_free()

func _on_timer_labels_timeout():
	current_character_visible_count += 1

	var current_label = all_story_labels[current_label_index]
	current_label.text = current_label_full_text 
	current_label.visible_characters = current_character_visible_count 

	# Detiene el timer y muestra el botón de continuar
	if current_character_visible_count >= current_label_full_text.length():
		label_timer.stop()
		continuar_button.visible = true

func _on_saltar_button_pressed() -> void:
	_exit_cinematic()

func _on_continuar_button_pressed() -> void:
	continuar_button.visible = false
	comenzar_historia()
