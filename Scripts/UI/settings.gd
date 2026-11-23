class_name Settings
extends Control


func _ready() -> void:
	AudioManager.pause.play()
	if get_tree().current_scene is Aquarium:
		get_tree().current_scene.deselect_fish()


func _on_resume_button_pressed() -> void:
	queue_free()


func _on_settings_pressed() -> void:
	pass


func _on_exit_to_menu_pressed() -> void:
	pass


func _on_exit_to_desktop_pressed() -> void:
	SaveManager.save_game()
	get_tree().quit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		queue_free()
		accept_event()


func _exit_tree() -> void:
	AudioManager.pause_reversed.play()
