extends Control

@onready var puntuacion_mg_1: Button = $VBoxContainer/PuntuacionMG1
@onready var puntuacion_mg_2: Button = $VBoxContainer/PuntuacionMG2
@onready var puntuacion_mg_3: Button = $VBoxContainer/PuntuacionMG3

@onready var volver_button: Button = $VolverContainer/VolverButton

var tabla_actual_instancia = null
# Precargamos la escena plantilla del plugin
# Asegúrate de que la ruta sea correcta según tu proyecto
const LEADERBOARD_SCENE = preload("res://addons/silent_wolf/Scores/Leaderboard.tscn")

func _ready():
	volver_button.grab_focus()
	# Conectar botones (o hazlo desde el editor si prefieres)
	puntuacion_mg_1.pressed.connect(func(): _abrir_tabla("ID1"))
	puntuacion_mg_2.pressed.connect(func(): _abrir_tabla("ID2"))
	puntuacion_mg_3.pressed.connect(func(): _abrir_tabla("ID3"))

func _abrir_tabla(nombre_nivel_interno: String):
# 1. PASO CRÍTICO: Limpieza de la tabla anterior (Visual)
	if tabla_actual_instancia != null:
		tabla_actual_instancia.queue_free()
		tabla_actual_instancia = null
	
	# 2. PASO CRÍTICO: Limpieza de la memoria de SilentWolf (Datos)
	# Esto obliga al plugin a olvidar lo que cargó antes
	SilentWolf.Scores.scores = []
	#SilentWolf.Scores.leaderboard_id = ""
	# 1. Obtenemos el ID real de SilentWolf desde tu diccionario global
	# (Recuerda que en el paso anterior configuramos este mapa en TablaDePuntuaciones)
	var id_real = TablaDePuntuaciones.mapa_minigames.get(nombre_nivel_interno)
	
	if id_real == null:
		print("Error: No existe ID para ", nombre_nivel_interno)
		return

	# 2. Instanciamos la escena del plugin
	tabla_actual_instancia = LEADERBOARD_SCENE.instantiate()
	
	# 3. ¡EL TRUCO! Configuramos el ID *antes* de añadirla al árbol
	# Esto hace que cuando arranque, cargue la tabla correcta.
	tabla_actual_instancia.ld_name = id_real
	
	# Opcional: Ocultar el menú actual para que se vea la tabla
	self.visible = false
	
	print("tabla_instance: ", tabla_actual_instancia.ld_name)
	# 4. Añadimos la tabla a la pantalla
	# Puedes añadirla a un nodo contenedor o directamente a la raíz
	get_tree().root.add_child(tabla_actual_instancia)
	
	# 5. Gestionar el botón "Cerrar" de la tabla
	# La escena de SilentWolf suele tener un botón de cerrar que recarga la escena
	# o emite una señal. Si quieres que vuelva a este menú, tendrías que 
	# modificar ligeramente la escena Leaderboard.tscn o conectar su señal de cierre.


func _on_volver_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/Menu_Minigames.tscn")
