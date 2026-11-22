extends Node

@export var available_fish: Array[FishSpeciesResource]

var aquarium_prices: Array = [25000, 100000, 500000, 1000000, 10000000]

var capacity_upgrade_increases: Array[int] = [5, 10, 15, 25, 40]
var capacity_upgrade_prices: Array[Array] = [
	[2500.0, 5000.0, 10000.0, 15000.0, 25000.0], # Aquarium 0
	[10000.0, 20000.0, 35000.0, 60000.0, 100000.0], # Aquarium 1
	[50000.0, 100000.0, 175000.0, 300000.0, 500000.0], # Aquarium 2
	[100000.0, 200000.0, 350000.0, 600000.0, 1000000.0], # Aquarium 3
	[1000000.0, 2000000.0, 3500000.0, 6000000.0, 10000000.0], # Aquarium 4
	[1000000.0, 2000000.0, 3500000.0, 6000000.0, 10000000.0] # Aquarium 5
]


func _process(delta: float) -> void:
	earn_passive_income(delta)


func earn_passive_income(delta) -> void:
	var income: float = 0.0
	
	for aquarium: AquariumResource in SaveManager.game_data.owned_aquariums:
		for fish_data: AquariumFishData in aquarium.fish:
			var fish = fish_data.fish
			income += fish.species.click_value * fish.species.passive_income_percent
	
	SaveManager.game_data.money += income * delta


func add_fish_to_aquarium(fish_instance: FishInstanceResource, aquarium_res: AquariumResource, position: Vector3) -> void:
	var data: AquariumFishData = AquariumFishData.new()
	data.fish = fish_instance
	data.position = position
	aquarium_res.fish.append(data)


func set_resolution(width: int, height: int) -> void:
	var size = Vector2i(width, height)
	DisplayServer.window_set_size(size)
	
	var screen = DisplayServer.window_get_current_screen()
	var screen_size = DisplayServer.screen_get_size(screen)
	var position = DisplayServer.screen_get_position(screen)
	
	@warning_ignore("integer_division")
	DisplayServer.window_set_position(position + (screen_size - size) / 2)
