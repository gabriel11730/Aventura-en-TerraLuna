extends CanvasLayer
class_name Interfaz

signal stick_controller(s: Stick)

@export var MENU_PAUSA_SCENE: PackedScene
@export var MENU_SEND_DATA: PackedScene
@export var heart: Texture2D
@export var heart_empty: Texture2D

@onready var stats_container: HBoxContainer = $StatsContainer/HeartsContainer
@onready var heart_1: TextureRect = $StatsContainer/HeartsContainer/Heart1
@onready var heart_2: TextureRect = $StatsContainer/HeartsContainer/Heart2
@onready var heart_3: TextureRect = $StatsContainer/HeartsContainer/Heart3
@onready var heart_4: TextureRect = $StatsContainer/HeartsContainer/Heart4
@onready var heart_5: TextureRect = $StatsContainer/HeartsContainer/Heart5

@onready var button_container: Control = $ButtonContainer
@onready var stick_container: Control = $StickContainer

@onready var hearts: Array[TextureRect] = [heart_1,heart_2,heart_3,heart_4,heart_5]

@onready var coins_collected: Label = $StatsContainer/CoinsContainer/CoinsCollected

@onready var pause_container: Control = $PauseContainer
@onready var save_container: Control = $SaveContainer

@onready var cuenta_regresiva: Label = $Cuenta_Regresiva

var _can_save: bool = false
#Teclas
var guardar : String = "save_game"
var pausa : String = "ui_cancel"

func _ready() -> void:
	if OS.has_feature("pc"):
		button_container.hide()
		stick_container.hide()
	stick_controller.emit($StickContainer/Stick)
	GameState.actualizar_vida.connect(actualizar_vida)
	actualizar_vida(GameState.get_life())
	GameState.actualizar_coins.connect(actualizar_monedas)
	actualizar_monedas(GameState.get_coins())
	LoadSavedGame.can_save.connect(can_save)
	TablaDePuntuaciones.menu_send_data.connect(_enviar_datos)

func _process(_delta: float) -> void:
	pass

func actualizar_vida(life: int):
	for i in range(hearts.size()):
		var heart_index = i + 1
		if life >= heart_index:
			hearts[i].texture = heart 
		else:
			hearts[i].texture = heart_empty

func actualizar_monedas(coins: int):
	coins_collected.text = " x %02d" % coins

func can_save(estado: int):
	_can_save = estado
	if estado:
		save_container.show()
	else:
		save_container.hide()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(guardar) and _can_save:
		LoadSavedGame.save_game()
		
	if event.is_action_pressed(pausa):
		_paused_game()

func _on_button_save_pressed() -> void:
	LoadSavedGame.save_game()
	#Enviar señal para ejecutar la logica de guardado

func _on_button_pause_pressed() -> void:
	_paused_game()
	
func _paused_game():
	if not get_tree().paused: 
		var menu_instance = MENU_PAUSA_SCENE.instantiate()
		# Añadimos el menú a la raíz del árbol para que esté por encima de todo
		get_tree().root.add_child(menu_instance)

func _enviar_datos():
	if not get_tree().paused: 
		var menu_instance = MENU_SEND_DATA.instantiate()
		# Añadimos el menú a la raíz del árbol para que esté por encima de todo
		get_tree().root.add_child(menu_instance)

func GameOver():
	GameState.game_over() #El singleton definira la escena que sera cargada
