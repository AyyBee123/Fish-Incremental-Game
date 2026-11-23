class_name FishInfo
extends Control

@onready var purchased_container: HBoxContainer = %PurchasedContainer
@onready var species_container: HBoxContainer = %SpeciesContainer


func _process(_delta: float) -> void:
	if get_tree().current_scene is Aquarium and get_tree().current_scene.selected_fish == null:
		queue_free()


func display_info(fish: Fish) -> void:
	AudioManager.popup_high_pitch.play()
	var date = Time.get_datetime_dict_from_unix_time(fish.fish_res.purchase_timestamp)
	var formatted_date = "%02d/%02d/%04d" % [date.day, date.month, date.year]
	
	%NameLabel.text = fish.fish_res.fish_name
	%SpeciesLabel.text = fish.fish_res.species.species_name
	%DateLabel.text = formatted_date
	
	populate_upgrades(fish)


func populate_upgrades(fish: Fish) -> void:
	var species = fish.fish_res.species

	# clear existing entries
	for child in purchased_container.get_children():
		child.queue_free()

	for child in species_container.get_children():
		child.queue_free()

	# purchased upgrades
	var species_data: SpeciesSaveData = GameManager.get_species_save_data(species)

	for upgrade_id: String in species_data.purchased_upgrades:
		var upgrade: UpgradeResource = GameManager.get_species_upgrade(upgrade_id, species.available_upgrades)

		if upgrade == null:
			continue

		var button: FishUpgradeButton = Preloads.FISH_UPGRADE_BUTTON.instantiate()
		button.upgrade_name = upgrade.upgrade_name
		button.description = upgrade.description
		button.price = upgrade.price
		button.disabled = true

		purchased_container.add_child(button)
	
	# available upgrades
	for upgrade: UpgradeResource in species.available_upgrades:
		if species_data.purchased_upgrades.has(upgrade.id):
			continue
		
		var button: FishUpgradeButton = Preloads.FISH_UPGRADE_BUTTON.instantiate()
		
		button.upgrade_name = upgrade.upgrade_name
		button.description = upgrade.description
		button.price = upgrade.price
		
		button.pressed.connect(_on_species_upgrade_pressed.bind(fish, upgrade))
		
		species_container.add_child(button)


func _on_species_upgrade_pressed(fish: Fish, upgrade: UpgradeResource) -> void:
	if GameManager.purchase_species_upgrade(fish.fish_res, upgrade):
		AudioManager.cash.play()
		populate_upgrades(fish)


func _on_close_button_pressed() -> void:
	get_tree().current_scene.deselect_fish()
	queue_free()


func _on_sell_button_pressed() -> void:
	if get_tree().current_scene is Aquarium:
		get_tree().current_scene.sell_fish()


func _exit_tree() -> void:
	AudioManager.popup_reversed_high_pitch.play()
