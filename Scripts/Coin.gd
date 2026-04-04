extends Node2D

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

func _on_coin_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Personaje"):
		GameState.sumar_monedas()
		$AudioStreamPlayer2D.play()
		$".".visible = false


func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
