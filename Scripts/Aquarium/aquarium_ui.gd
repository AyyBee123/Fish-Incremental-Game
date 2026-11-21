extends Control

@export var aquarium: Aquarium

var current_shop: Shop


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shop"):
		if current_shop:
			close_shop()
		else:
			open_shop()
		accept_event()
	if event.is_action_pressed("back"):
		close_shop()
		accept_event()


func open_shop() -> void:
	if current_shop: return
	var shop: Shop = Preloads.SHOP.instantiate()
	add_child(shop)


func close_shop() -> void:
	if current_shop:
		current_shop.queue_free()


func _on_shop_button_pressed() -> void:
	open_shop()


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.
