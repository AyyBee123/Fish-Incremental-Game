class_name UpgradeEffect
extends Resource

func get_click_increase(_fish: FishInstanceResource) -> float:
	return 0.0


func get_click_multiplier(_fish: FishInstanceResource) -> float:
	return 1.0


func get_passive_income_percent(_fish: FishInstanceResource) -> float:
	return 0.0


func get_click_size_increase() -> float:
	return 0.0


func get_click_size_multiplier() -> float:
	return 1.0


func apply_on_click(_clicked_fish: Fish, _fish_manager: FishManager) -> float:
	return 0.0
