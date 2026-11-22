class_name FlatClickUpgrade
extends FishUpgradeEffect

@export var click_percent: float = 0.1

func calculate_bonus(_fish: FishInstanceResource) -> float:
	return click_percent
