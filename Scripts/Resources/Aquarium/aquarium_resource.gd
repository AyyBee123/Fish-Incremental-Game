class_name AquariumResource
extends Resource

@export var id: int = 0
@export var aquarium_name: String = "Aquarium"
@export var max_capacity: int = 5
@export var purchased_capacity_upgrades: Array[bool] = [false, false, false, false, false]
@export var fish: Array[AquariumFishData] = []
