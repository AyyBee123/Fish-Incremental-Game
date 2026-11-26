extends Node

const MAX_OFFLINE_SECONDS: int = 8 * 60 * 60 # first number is in hours

var PATH: String = "user://save.res"

var game_data: GameDataResource


func _ready() -> void:
	load_game()
	GameManager.passive_income_per_second = GameManager.get_passive_income_per_second()


func save_game() -> void:
	var aquarium = game_data.current_aquarium
	var fish_manager = get_tree().get_first_node_in_group("fish_manager")
	
	if aquarium and fish_manager:
		aquarium.fish.clear()
		
		for fish_node: Fish in fish_manager.get_children():
			var fish_data = AquariumFishData.new()
			fish_data.fish = fish_node.fish_res
			fish_data.position = fish_node.global_position
			fish_data.rotation = fish_node.global_rotation
			aquarium.fish.append(fish_data)
	
	game_data.last_save_timestamp = int(Time.get_unix_time_from_system())
	
	var error: Error = ResourceSaver.save(game_data, PATH)
	
	# debug copy for inspection in the editor
	ResourceSaver.save(game_data, "res://save_debug.tres")
	
	if error != OK:
		push_error("Failed to save game: " + str(error))


func load_game() -> void:
	if ResourceLoader.exists(PATH):
		game_data = ResourceLoader.load(PATH) as GameDataResource
	else:
		game_data = GameDataResource.new()
		game_data.last_save_timestamp = int(Time.get_unix_time_from_system())
		return
	
	var current_timestamp: int = int(Time.get_unix_time_from_system())
	var elapsed_time: int = current_timestamp - game_data.last_save_timestamp
	elapsed_time = clampi(elapsed_time, 0, MAX_OFFLINE_SECONDS)
	
	if elapsed_time > 0:
		var offline_income: float = GameManager.get_passive_income_per_second() * elapsed_time
		game_data.money += offline_income
