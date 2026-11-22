class_name FishInfo
extends Control


func _process(_delta: float) -> void:
	if get_tree().current_scene is Aquarium and get_tree().current_scene.selected_fish == null:
		queue_free()


func display_info(fish: Fish) -> void:
	var date = Time.get_datetime_dict_from_unix_time(fish.fish_res.purchase_timestamp)
	var formatted_date = "%02d/%02d/%04d" % [date.day, date.month, date.year]
	
	%NameLabel.text = fish.fish_res.fish_name
	%SpeciesLabel.text = fish.fish_res.species.species_name
	%DateLabel.text = formatted_date


func _on_close_button_pressed() -> void:
	get_tree().current_scene.deselect_fish()
	queue_free()


func _on_sell_button_pressed() -> void:
	if get_tree().current_scene is Aquarium:
		get_tree().current_scene.sell_fish()
