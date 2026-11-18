extends Node

var money: float = 0.0
var owned_fish: Array[FishInstanceResource] = []


func _process(delta: float) -> void:
	var income: float = 0.0
	
	for fish in owned_fish:
		# calculate the fish's passive income per second
		pass
	
	money += income * delta


func add_fish(fish: FishInstanceResource) -> void:
	owned_fish.append(fish)


func remove_fish(fish: FishInstanceResource) -> void:
	owned_fish.erase(fish)
