extends Node

@export var available_fish: Array[FishSpeciesResource]

var aquarium_prices: Array = [25000, 100000, 500000, 1000000, 10000000]

var capacity_upgrade_increases: Array[int] = [5, 10, 15, 25, 40]
var capacity_upgrade_prices: Array[Array] = [
	[2500.0, 5000.0, 10000.0, 15000.0, 25000.0], # Aquarium 0
	[10000.0, 20000.0, 35000.0, 60000.0, 100000.0], # Aquarium 1
	[50000.0, 100000.0, 175000.0, 300000.0, 500000.0], # Aquarium 2
	[100000.0, 200000.0, 350000.0, 600000.0, 1000000.0], # Aquarium 3
	[1000000.0, 2000000.0, 3500000.0, 6000000.0, 10000000.0], # Aquarium 4
	[1000000.0, 2000000.0, 3500000.0, 6000000.0, 10000000.0] # Aquarium 5
]

@export var individual_fish_upgrades: Array[UpgradeResource]
@export var species_upgrades: Array[UpgradeResource]
@export var global_upgrades: Array[UpgradeResource]


func _process(delta: float) -> void:
	earn_passive_income(delta)


func earn_passive_income(delta: float) -> void:
	SaveManager.game_data.money += get_passive_income_per_second() * delta


func get_passive_income_per_second() -> float:
	var income: float = 0.0
	
	for aquarium: AquariumResource in SaveManager.game_data.owned_aquariums:
		for fish_data: AquariumFishData in aquarium.fish:
			var fish: FishInstanceResource = fish_data.fish
			var click_value: float = get_fish_click_value(fish)
			var passive_percent: float = get_passive_income_percent(fish)
			
			income += click_value * passive_percent
	
	return income


func get_total_click_increase(fish: FishInstanceResource) -> float:
	var increase: float = 0.0
	
	for upgrade_id: String in fish.purchased_upgrades:
		var upgrade: UpgradeResource = get_upgrade(upgrade_id)
		if upgrade and upgrade.effect:
			increase += upgrade.effect.get_click_increase(fish)
	
	for upgrade_id: String in fish.species.purchased_upgrades:
		var upgrade: UpgradeResource = get_species_upgrade(upgrade_id)
		if upgrade and upgrade.effect:
			increase += upgrade.effect.get_click_increase(fish)
	
	for upgrade_id: String in SaveManager.game_data.purchased_global_upgrades:
		var upgrade: UpgradeResource = get_global_upgrade(upgrade_id)
		if upgrade and upgrade.effect:
			increase += upgrade.effect.get_click_increase(fish)
	
	return increase


func get_total_click_multiplier(fish: FishInstanceResource) -> float:
	var multiplier: float = 1.0
	
	for upgrade_id: String in fish.purchased_upgrades:
		var upgrade: UpgradeResource = get_upgrade(upgrade_id)
		if upgrade and upgrade.effect:
			multiplier *= upgrade.effect.get_click_multiplier(fish)
	
	for upgrade_id: String in fish.species.purchased_upgrades:
		var upgrade: UpgradeResource = get_species_upgrade(upgrade_id)
		if upgrade and upgrade.effect:
			multiplier *= upgrade.effect.get_click_multiplier(fish)
	
	for upgrade_id: String in SaveManager.game_data.purchased_global_upgrades:
		var upgrade: UpgradeResource = get_global_upgrade(upgrade_id)
		if upgrade and upgrade.effect:
			multiplier *= upgrade.effect.get_click_multiplier(fish)
	
	return multiplier


func get_passive_income_percent(fish: FishInstanceResource) -> float:
	var percent: float = 0.0
	
	for upgrade_id: String in fish.purchased_upgrades:
		var upgrade: UpgradeResource = get_upgrade(upgrade_id)
		if upgrade and upgrade.effect:
			percent += upgrade.effect.get_passive_income_percent(fish)
	
	for upgrade_id: String in fish.species.purchased_upgrades:
		var upgrade: UpgradeResource = get_species_upgrade(upgrade_id)
		if upgrade and upgrade.effect:
			percent += upgrade.effect.get_passive_income_percent(fish)
	
	for upgrade_id: String in SaveManager.game_data.purchased_global_upgrades:
		var upgrade: UpgradeResource = get_global_upgrade(upgrade_id)
		if upgrade and upgrade.effect:
			percent += upgrade.effect.get_passive_income_percent(fish)
	
	return percent


func get_fish_click_value(fish: FishInstanceResource) -> float:
	return fish.species.click_value * (1.0 + get_total_click_increase(fish)) * get_total_click_multiplier(fish)


func get_global_click_bonus(clicked_fish: Fish) -> float:
	var bonus: float = 0.0
	var fish_manager: FishManager = get_tree().get_first_node_in_group("fish_manager")
	
	if not fish_manager:
		return bonus
	
	for upgrade_id: String in SaveManager.game_data.purchased_global_upgrades:
		var upgrade: UpgradeResource = get_global_upgrade(upgrade_id)
		
		if upgrade and upgrade.effect:
			bonus += upgrade.effect.apply_on_click(clicked_fish, fish_manager)
	
	return bonus


func get_total_click_size_increase() -> float:
	var increase: float = 0.0
	
	for upgrade_id: String in SaveManager.game_data.purchased_global_upgrades:
		var upgrade: UpgradeResource = get_global_upgrade(upgrade_id)
		if upgrade and upgrade.effect:
			increase += upgrade.effect.get_click_size_increase()
	
	return increase


func get_total_click_size_multiplier() -> float:
	var multiplier: float = 1.0
	
	for upgrade_id: String in SaveManager.game_data.purchased_global_upgrades:
		var upgrade: UpgradeResource = get_global_upgrade(upgrade_id)
		if upgrade and upgrade.effect:
			multiplier *= upgrade.effect.get_click_size_multiplier()
	
	return multiplier


func get_upgrade(upgrade_id: String) -> UpgradeResource:
	for upgrade: UpgradeResource in individual_fish_upgrades:
		if upgrade.id == upgrade_id:
			return upgrade
	
	return null


func get_species_upgrade(upgrade_id: String) -> UpgradeResource:
	for upgrade: UpgradeResource in species_upgrades:
		if upgrade.id == upgrade_id:
			return upgrade
	
	return null


func get_global_upgrade(upgrade_id: String) -> UpgradeResource:
	for upgrade: UpgradeResource in global_upgrades:
		if upgrade.id == upgrade_id:
			return upgrade
	
	return null


func get_fish_sell_price(fish: FishInstanceResource) -> float:
	var original_price: float = fish.species.price
	var upgrade_cost: float = fish.personal_upgrade_spent
	
	return (original_price + upgrade_cost) * 0.5


func add_fish_to_aquarium(fish_instance: FishInstanceResource, aquarium_res: AquariumResource, position: Vector3) -> void:
	var data: AquariumFishData = AquariumFishData.new()
	data.fish = fish_instance
	data.position = position
	aquarium_res.fish.append(data)


func set_resolution(width: int, height: int) -> void:
	var size = Vector2i(width, height)
	DisplayServer.window_set_size(size)
	
	var screen = DisplayServer.window_get_current_screen()
	var screen_size = DisplayServer.screen_get_size(screen)
	var position = DisplayServer.screen_get_position(screen)
	
	@warning_ignore("integer_division")
	DisplayServer.window_set_position(position + (screen_size - size) / 2)
