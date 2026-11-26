class_name Shop
extends Control

@onready var margin_container: MarginContainer = %MarginContainer
@onready var category_view: ScrollContainer = %CategoryView
@onready var fish_view: ScrollContainer = %FishView
@onready var aquarium_view: ScrollContainer = %AquariumView
@onready var capacity_view: ScrollContainer = %CapacityView
@onready var upgrade_view: ScrollContainer = %UpgradeView


func _ready() -> void:
	AudioManager.popup.play()
	category_view.show()
	get_tree().current_scene.deselect_fish()
	for node in margin_container.get_children():
		if node == category_view: continue
		node.hide()


func populate_fish_shop() -> void:
	for node in fish_view.get_node("Grid").get_children():
		node.queue_free()
	for species: FishSpeciesResource in GameManager.available_fish:
		if not species.is_unlocked: continue
		var button: ShopFishButton = Preloads.SHOP_FISH_BUTTON.instantiate()
		button.price = species.price
		button.image = species.image
		button.fish_name = species.species_name
		button.pressed.connect(buy_fish.bind(species))
		fish_view.get_node("Grid").add_child(button)


func buy_fish(species: FishSpeciesResource) -> void:
	var aquarium: AquariumResource = get_tree().current_scene.aquarium_res
	
	if aquarium.fish.size() >= aquarium.max_capacity:
		return
	if SaveManager.game_data.money < species.price:
		return
	
	SaveManager.game_data.money -= species.price
	
	var manager: FishManager = get_tree().current_scene.fish_manager
	manager.spawn_fish(manager.create_fish(species, manager.fish_names.pick_random()), true, true)
	
	get_tree().current_scene.update_capacity_label()
	SaveManager.save_game()
	AudioManager.cash.play()


func populate_aquarium_shop() -> void:
	for node in aquarium_view.get_node("Grid").get_children():
		node.queue_free()
	
	for i in range(1, GameManager.aquarium_prices.size() + 1):
		var already_owned = false
		
		for aquarium: AquariumResource in SaveManager.game_data.owned_aquariums:
			if aquarium.id == i:
				already_owned = true
				break
		
		if already_owned:
			continue
		
		var button: ShopAquariumButton = Preloads.SHOP_AQUARIUM_BUTTON.instantiate()
		button.price = GameManager.aquarium_prices[i - 1]
		button.aquarium_name = "Aquarium %s" % (i)
		button.pressed.connect(buy_aquarium.bind(i))
		aquarium_view.get_node("Grid").add_child(button)


func buy_aquarium(id: int) -> void:
	var price = GameManager.aquarium_prices[id - 1]
	
	if SaveManager.game_data.money < price:
		return
	
	SaveManager.game_data.money -= price
	
	var aquarium = AquariumResource.new()
	aquarium.id = id
	aquarium.aquarium_name = "Aquarium %s" % (id + 1)
	
	SaveManager.game_data.owned_aquariums.append(aquarium)
	
	SaveManager.save_game()
	get_tree().current_scene.populate_aquarium_list()
	populate_aquarium_shop()
	AudioManager.cash.play()


func populate_capacity_shop() -> void:
	for node in capacity_view.get_node("Grid").get_children():
		node.queue_free()
	
	var aquarium: AquariumResource = get_tree().current_scene.aquarium_res
	
	for i in range(GameManager.capacity_upgrade_prices[aquarium.id].size()):
		if aquarium.purchased_capacity_upgrades[i]:
			continue
		
		var button: ShopCapacityButton = Preloads.SHOP_CAPACITY_BUTTON.instantiate()
		button.price = GameManager.capacity_upgrade_prices[aquarium.id][i]
		button.capacity_increase = GameManager.capacity_upgrade_increases[i]
		button.pressed.connect(buy_capacity_upgrade.bind(i))
		capacity_view.get_node("Grid").add_child(button)


func buy_capacity_upgrade(upgrade_id: int) -> void:
	var aquarium: AquariumResource = get_tree().current_scene.aquarium_res
	
	if aquarium.purchased_capacity_upgrades[upgrade_id]:
		return
	
	var price: float = GameManager.capacity_upgrade_prices[aquarium.id][upgrade_id]
	
	if SaveManager.game_data.money < price:
		return
	
	SaveManager.game_data.money -= price
	aquarium.purchased_capacity_upgrades[upgrade_id] = true
	aquarium.max_capacity += GameManager.capacity_upgrade_increases[upgrade_id]
	
	SaveManager.save_game()
	get_tree().current_scene.update_capacity_label()
	populate_capacity_shop()
	AudioManager.cash.play()


func populate_upgrade_shop() -> void:
	for node in upgrade_view.get_node("Grid").get_children():
		node.queue_free()
	
	for upgrade: UpgradeResource in GameManager.global_upgrades:
		var already_purchased: bool = SaveManager.game_data.purchased_global_upgrades.has(upgrade.id)
		if already_purchased:
			continue
		
		var button: ShopUpgradeButton = Preloads.SHOP_UPGRADE_BUTTON.instantiate()
		button.price = upgrade.price
		button.upgrade_name = upgrade.upgrade_name
		button.pressed.connect(buy_upgrade.bind(upgrade))
		button.pressed.connect(get_tree().get_first_node_in_group("click_circle").update_circle_radius)
		upgrade_view.get_node("Grid").add_child(button)


func buy_upgrade(upgrade: UpgradeResource) -> void:
	if SaveManager.game_data.purchased_global_upgrades.has(upgrade.id):
		return
	
	if SaveManager.game_data.money < upgrade.price:
		return
	
	SaveManager.game_data.money -= upgrade.price
	SaveManager.game_data.purchased_global_upgrades.append(upgrade.id)
	
	SaveManager.save_game()
	populate_upgrade_shop()
	AudioManager.cash.play()
	
	GameManager.passive_income_per_second = GameManager.get_passive_income_per_second()


func _on_category_view_visibility_changed() -> void:
	%BackButton.visible = not %CategoryView.visible


func _on_close_button_pressed() -> void:
	queue_free()


func _on_back_button_pressed() -> void:
	category_view.show()
	for node in margin_container.get_children():
		if node == category_view: continue
		node.hide()
	AudioManager.button.play()


func _on_fish_button_pressed() -> void:
	category_view.hide()
	populate_fish_shop()
	fish_view.show()
	AudioManager.button.play()


func _on_aquarium_button_pressed() -> void:
	category_view.hide()
	populate_aquarium_shop()
	aquarium_view.show()
	AudioManager.button.play()


func _on_capacity_button_pressed() -> void:
	category_view.hide()
	populate_capacity_shop()
	capacity_view.show()
	AudioManager.button.play()


func _on_upgrade_button_pressed() -> void:
	category_view.hide()
	populate_upgrade_shop()
	upgrade_view.show()
	AudioManager.button.play()


func _exit_tree() -> void:
	AudioManager.popup_reversed.play()
