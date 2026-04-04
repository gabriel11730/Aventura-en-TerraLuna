extends Node2D

@export var id_minijuego: String = "ID1"
@export var portal_position: Vector2

@onready var portal: Node2D = $Portals/Portal
@onready var label_crono: Label = $CanvasLayer/Control/Label_Crono

var tiempo_transcurrido : float = 0.0
var cronometro_activo : bool = false
var cant_coins: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.life_personaje = GameState.life_max
	GameState.take_damage(2)
	GameState.is_history_level = false
	GameState.ruta_level_actual = get_tree().current_scene.scene_file_path
	GameState.coins = 0
	portal.global_position = Vector2 (-100,0)
	_monedas_in_game()
	iniciar_cronometro()


func _process(delta):
	if cronometro_activo:
		tiempo_transcurrido += delta
		if Engine.get_frames_drawn() % 3 == 0:
			label_crono.text = _formatear_tiempo(tiempo_transcurrido)


func _monedas_in_game():
	var coins = get_tree().get_nodes_in_group("Coins")
	cant_coins = coins.size()


func _physics_process(_delta: float) -> void:
	if GameState.get_coins() == cant_coins:
		portal.global_position = portal_position


func terminar_minijuego():
	var tiempo = detener_cronometro()
	TablaDePuntuaciones.fin_minigame(tiempo, id_minijuego)
	

func iniciar_cronometro():
	tiempo_transcurrido = 0.0
	cronometro_activo = true

func detener_cronometro():
	cronometro_activo = false
	return tiempo_transcurrido

# Esta función convierte los segundos crudos en formato MM:SS.mm
func _formatear_tiempo(tiempo: float) -> String:
	var minutos = int(tiempo / 60)
	var segundos = int(tiempo) % 60
	var milisegundos = int((tiempo - int(tiempo)) * 100)
	return "%02d:%02d.%02d" % [minutos, segundos, milisegundos]
