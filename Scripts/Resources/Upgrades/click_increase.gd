class_name ClickIncrease
extends UpgradeEffect

@export var click_percent: float = 0.1

func get_click_increase(_fish: FishInstanceResource) -> float:
	return click_percent
