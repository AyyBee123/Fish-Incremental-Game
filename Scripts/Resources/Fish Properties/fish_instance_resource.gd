class_name FishInstanceResource
extends Resource

@export_category("Fish Properties")
@export var species: FishSpeciesResource
@export var fish_name: String

@export_category("Upgrades")
@export var purchased_upgrades: Array[String] = []
@export var personal_upgrade_spent: float = 0.0

@export_category("Miscellaneous Properties")
@export var purchase_timestamp: int = 0

var aquarium_position: Vector3


func earn_passive_income(delta: float) -> void:
	var income: float = 0.0
	
	for aquarium: AquariumResource in SaveManager.game_data.owned_aquariums:
		for fish_data: AquariumFishData in aquarium.fish:
			var fish: FishInstanceResource = fish_data.fish
			var click_value: float = fish.species.click_value
			
			click_value *= 1.0 + get_total_click_increase(fish)
			click_value *= get_total_click_multiplier(fish)
			
			income += click_value
	
	SaveManager.game_data.money += income * delta
