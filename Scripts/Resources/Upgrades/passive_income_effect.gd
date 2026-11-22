class_name PassiveIncomeUpgradeEffect
extends UpgradeEffect

@export var passive_income_percent: float = 0.01

func get_passive_income_percent(_fish: FishInstanceResource) -> float:
	return passive_income_percent
