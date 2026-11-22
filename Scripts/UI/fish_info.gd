extends Control


func _process(_delta: float) -> void:
	if get_tree().current_scene is Aquarium and get_tree().current_scene.selected_fish == null:
		queue_free()


func _on_close_button_pressed() -> void:
	get_tree().current_scene.deselect_fish()
	queue_free()
