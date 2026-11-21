extends Node

var PATH: String = "user://save.res"

var game_data: GameDataResource


func _ready() -> void:
	load_game()


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
	
	var error: Error = ResourceSaver.save(game_data, PATH)
	
	if error == OK:
		print("Game saved!")
	else:
		push_error("Failed to save game: " + str(error))


func load_game() -> void:
	if ResourceLoader.exists(PATH):
		game_data = ResourceLoader.load(PATH) as GameDataResource
	else:
		game_data = GameDataResource.new()
