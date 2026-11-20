class_name Shop
extends Control

@onready var margin_container: MarginContainer = %MarginContainer
@onready var category_view: ScrollContainer = %CategoryView
@onready var fish_view: ScrollContainer = %FishView


func _ready() -> void:
	category_view.show()
	for node in margin_container.get_children():
		if node == category_view: continue
		node.hide()


func populate_fish_shop() -> void:
	for node in fish_view.get_node("FishGrid").get_children():
		node.queue_free()
	for species: FishSpeciesResource in GameManager.available_fish:
		if not species.is_unlocked: continue
		var button: ShopFishButton = Preloads.SHOP_FISH_BUTTON.instantiate()
		button.price = species.price
		button.image = species.image
		button.pressed.connect(buy_fish.bind(species))
		fish_view.get_node("FishGrid").add_child(button)


func buy_fish(species: FishSpeciesResource) -> void:
	var aquarium: AquariumResource = get_tree().current_scene.aquarium_res
	if aquarium.fish.size() >= aquarium.max_capacity: return
	if GameManager.money < species.price: return
	GameManager.money -= species.price
	var manager: FishManager = get_tree().current_scene.fish_manager
	manager.spawn_fish(manager.create_fish(species, manager.fish_names.pick_random()), true, true)


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


func _on_category_view_visibility_changed() -> void:
	%BackButton.visible = not %CategoryView.visible
