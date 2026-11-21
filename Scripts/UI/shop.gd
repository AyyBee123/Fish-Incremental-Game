class_name Shop
extends Control

@onready var margin_container: MarginContainer = %MarginContainer
@onready var category_view: ScrollContainer = %CategoryView
@onready var fish_view: ScrollContainer = %FishView
@onready var aquarium_view: ScrollContainer = %AquariumView


func _ready() -> void:
	category_view.show()
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
	aquarium.aquarium_name = "Aquarium %s" % (id)
	
	SaveManager.game_data.owned_aquariums.append(aquarium)
	
	SaveManager.save_game()
	get_tree().current_scene.populate_aquarium_list()
	populate_aquarium_shop()


func _on_category_view_visibility_changed() -> void:
	%BackButton.visible = not %CategoryView.visible


func _on_close_button_pressed() -> void:
	queue_free()


func _on_back_button_pressed() -> void:
	category_view.show()
	for node in margin_container.get_children():
		if node == category_view: continue
		node.hide()


func _on_fish_button_pressed() -> void:
	category_view.hide()
	populate_fish_shop()
	fish_view.show()


func _on_aquarium_button_pressed() -> void:
	category_view.hide()
	populate_aquarium_shop()
	aquarium_view.show()
