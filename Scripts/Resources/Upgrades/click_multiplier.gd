class_name ClickMultiplier
extends UpgradeEffect

@export var click_multiplier: float = 1.05

func get_click_multiplier(_fish: FishInstanceResource) -> float:
	return click_multiplier
