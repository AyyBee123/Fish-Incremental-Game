class_name UniqueSpeciesUpgrade
extends UpgradeEffect

@export var click_percent_per_species: float = 0.05

func calculate_bonus(fish: FishInstanceResource) -> float:
	var unique_species: Dictionary = {}
	
	for aquarium: AquariumResource in SaveManager.game_data.owned_aquariums:
		for fish_data: AquariumFishData in aquarium.fish:
			unique_species[fish_data.fish.species] = true
	
	return unique_species.size() * click_percent_per_species
