class_name ChainClickUpgrade
extends UpgradeEffect

@export var click_percent: float = 0.10

func apply_on_click(clicked_fish: Fish, fish_manager: FishManager) -> float:
	var bonus: float = 0.0
	
	for fish: Fish in fish_manager.get_children():
		if fish == clicked_fish:
			continue
		
		bonus += fish.get_click_value() * click_percent
	
	return bonus
