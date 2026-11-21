extends Node

const SAVE_INTERVAL: float = 300.0


func _ready() -> void:
	var save_timer = Timer.new()
	save_timer.wait_time = SAVE_INTERVAL
	save_timer.timeout.connect(SaveManager.save_game)
	save_timer.autostart = true
	add_child(save_timer)


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		SaveManager.save_game()
	elif what == NOTIFICATION_WM_CLOSE_REQUEST:
		SaveManager.save_game()
