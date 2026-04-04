extends Node
const MUSIC_MINIGAMES = preload("res://Recursos/Musica/music_minigames.wav")
const MUSIC_HISTORY = preload("res://Recursos/Musica/music_history.mp3")

@onready var background_music: AudioStreamPlayer = $BackgroundMusic
@onready var game_over_music: AudioStreamPlayer = $GameOverMusic

func change_music(op : bool):
	if op:
		background_music.stream = MUSIC_MINIGAMES
	else:
		background_music.stream = MUSIC_HISTORY
	background_music.play()
func play_music():
	background_music.play()

func pause_music() -> void:
	background_music.stream_paused = true

func resume_music() -> void:
	background_music.stream_paused = false

func is_playing() -> bool:
	return background_music.playing

func play_game_over_sound():
	background_music.stop()
	game_over_music.play()
	
func stop_game_over_music():
	game_over_music.stop()
	play_music()
#No se usan estas funciones por el momento
#func stop_music()-> void:
	#if background_music.playing == true:
		#background_music.stop()
#
#func play_music () -> void:
	#if background_music.stream != null:
		#background_music.play()
	#else :
		#print("falta asignar musica de fondo")
