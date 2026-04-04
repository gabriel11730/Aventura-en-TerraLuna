extends Node

signal menu_send_data

var leaderboard_actual_id : String = "main" # Por defecto del Plugin
var puntaje : float = 0

#Si creo mas niveles, primero creo una tabla en el Plugin, luego la vinculo aqui
var mapa_minigames = {
	"ID1" : "ID1",
	"ID2" : "ID2",
	"ID3" : "ID3"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SilentWolf.configure({
		"api_key": "q4Y5pszgfV1cnYn4JTf62aOnVyAhicQ64HUdSIQc",
		"game_id": "aventuraenterraluna",
		"log_level": 1
			})

	SilentWolf.configure_scores({
		"open_scene_on_close": "res://Scenes/Menus/Menu_Minigames.tscn"
			})

func _puntaje_actual(tiempo:float):
	puntaje = tiempo

func get_puntaje_actual():
	return puntaje



	
# MODIFICADO: Ahora recibe el ID del nivel
func fin_minigame(tiempo: float, id_nivel_recibido: String):
	_puntaje_actual(tiempo)
	
	# Verificamos si el ID existe en nuestro mapa
	if id_nivel_recibido in mapa_minigames:
		leaderboard_actual_id = mapa_minigames[id_nivel_recibido]
		print("Leaderboard seleccionado: " + leaderboard_actual_id)
	else:
		leaderboard_actual_id = "main" # Fallback por si acaso
		print("AVISO: ID de nivel no encontrado en el mapa, usando 'main'")
	
	menu_send_data.emit()

# MODIFICADO: Usa el ID seleccionado
func enviardatos(nombre: String):
	# SilentWolf.Scores.save_score(nombre_jugador, puntaje, id_leaderboard)
	# Nota: El 3er argumento es el ID de la leaderboard específica
	SilentWolf.Scores.save_score(nombre, get_puntaje_actual(), leaderboard_actual_id)
	
