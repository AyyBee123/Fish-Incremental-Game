extends Node

@export var available_fish: Array[FishSpeciesResource]

var aquarium_prices: Array = [25000, 100000, 500000, 1000000, 10000000]


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
