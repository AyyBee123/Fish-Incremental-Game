extends Node

@export var available_fish: Array[FishSpeciesResource]

var money: float = 0.0
var owned_fish: Array[FishInstanceResource] = []
var owned_aquariums: Array[AquariumResource] = []
var current_aquarium: AquariumResource


func _process(delta: float) -> void:
	earn_passive_income(delta)


func earn_passive_income(delta) -> void:
	var income: float = 0.0
	
	for fish: FishInstanceResource in owned_fish:
		# calculate the fish's passive income per second
		income += fish.species.click_value * fish.species.passive_income_percent
	
	money += income * delta


func add_fish(fish: FishInstanceResource) -> void:
	if not owned_fish.has(fish):
		owned_fish.append(fish)


func remove_fish(fish: FishInstanceResource) -> void:
	owned_fish.erase(fish)


func add_fish_to_aquarium(fish_instance: FishInstanceResource, aquarium_res: AquariumResource, position: Vector3) -> void:
	var data: AquariumFishData = AquariumFishData.new()
	data.fish = fish_instance
	data.position = position
	aquarium_res.fish.append(data)
