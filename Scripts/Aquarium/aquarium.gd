class_name Aquarium
extends Node3D

var aquarium_res: AquariumResource

@onready var ui: Control = %UI
@onready var camera: Camera3D = %Camera3D
@onready var fish_manager: Node = %"Fish Manager"
@onready var click_manager: Node = %"Click Manager"
@onready var indicator: Node3D = %Indicator
@onready var income_label: Label = %IncomeLabel

var selected_fish: Fish
var fish_info: FishInfo
var displayed_money: float:
	set(v):
		displayed_money = v
		%MoneyLabel.text = "$%s" % Utils.format_number_two_decimals(v)


func _ready() -> void:
	if SaveManager.game_data.current_aquarium:
		aquarium_res = SaveManager.game_data.current_aquarium
	else:
		aquarium_res = AquariumResource.new()
		SaveManager.game_data.current_aquarium = aquarium_res
	
	SaveManager.game_data.current_aquarium = aquarium_res
	displayed_money = SaveManager.game_data.money
	
	var owned_aquariums: Array = SaveManager.game_data.owned_aquariums
	if not owned_aquariums.has(aquarium_res):
		aquarium_res.aquarium_name = "Aquarium %s" % (owned_aquariums.size() + 1)
		owned_aquariums.append(aquarium_res)
		if owned_aquariums.size() > 1:
			aquarium_res.aquarium_name = "Aquarium %s" % (owned_aquariums.size())
	
	populate_aquarium_list()
	update_capacity_label()
	
	if aquarium_res.fish.is_empty() and aquarium_res.id == 0:
		# new aquarium
		fish_manager.spawn_fish(fish_manager.create_fish(preload("uid://df20jvqg3ut1w"), fish_manager.fish_names.pick_random()), true)
	else:
		# spawn fish assigned to this aquarium
		for fish_data in aquarium_res.fish:
			fish_manager.spawn_fish(fish_data.fish, false, false, fish_data.position, fish_data.rotation)


func _process(delta: float) -> void:
	if displayed_money != SaveManager.game_data.money:
		displayed_money = lerpf(displayed_money, SaveManager.game_data.money, 1.0 - exp(-25.0 * delta))
	
	if selected_fish:
		indicator.global_position = selected_fish.global_position + Vector3.UP * 3.0
	
	income_label.text = "+$%s / sec" % Utils.format_number_two_decimals(GameManager.passive_income_per_second)
	if GameManager.passive_income_per_second <= 0:
		income_label.hide()
	else:
		income_label.show()


func switch_aquarium(new_aquarium: AquariumResource) -> void:
	AudioManager.button.play()
	SaveManager.save_game() # save the currently active aquarium and its fish
	SaveManager.game_data.current_aquarium = new_aquarium # change the active aquarium
	ResourceSaver.save(SaveManager.game_data, SaveManager.PATH) # save new selection without getting the old aquarium's fish
	get_tree().reload_current_scene() # reload the aquarium scene


func populate_aquarium_list() -> void:
	for node in %AquariumList.get_children():
		node.queue_free()
	
	for aquarium: AquariumResource in SaveManager.game_data.owned_aquariums:
		if aquarium == SaveManager.game_data.current_aquarium:
			continue
		
		var button: AquariumSelectionButton = Preloads.AQUARIUM_BUTTON.instantiate()
		button.setup(aquarium)
		button.pressed.connect(switch_aquarium.bind(aquarium))
		%AquariumList.add_child(button)


func update_capacity_label() -> void:
	var current: int = aquarium_res.fish.size()
	var capacity: int = aquarium_res.max_capacity
	
	if current >= capacity:
		%CapacityLabel.text = "[color=red]%d[/color]/%d" % [current, capacity]
	else:
		%CapacityLabel.text = "%d/%d" % [current, capacity]


func select_fish(fish: Fish) -> void:
	if selected_fish == fish:
		return
	
	indicator.show()
	indicator.global_position = fish.global_position + Vector3.UP * 2.0
	
	if not selected_fish:
		fish_info = Preloads.FISH_INFO.instantiate()
		ui.add_child(fish_info)
	
	selected_fish = fish
	
	fish_info.display_info(fish)


func deselect_fish() -> void:
	indicator.hide()
	if fish_info:
		fish_info._on_close_button_pressed()
	selected_fish = null


func sell_fish() -> void:
	if not is_instance_valid(selected_fish):
		return

	var fish: Fish = selected_fish
	var fish_resource: FishInstanceResource = fish.fish_res

	# count fish across all aquariums
	var total_fish: int = 0
	for aquarium: AquariumResource in SaveManager.game_data.owned_aquariums:
		total_fish += aquarium.fish.size()
	
	if total_fish <= 1:
		return
	
	var sell_price: float = GameManager.get_fish_sell_price(fish_resource)
	
	deselect_fish()
	
	fish_manager.remove_child(fish)
	fish.queue_free()
	
	SaveManager.game_data.money += sell_price
	SaveManager.save_game()
	
	update_capacity_label()


func get_fish_sell_price(fish: FishInstanceResource) -> float:
	return fish.species.price * 0.5


func get_total_fish_count() -> int:
	var total: int = 0
	
	for aquarium: AquariumResource in SaveManager.game_data.owned_aquariums:
		total += aquarium.fish.size()
	
	return total


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click") or event.is_action_pressed("back"):
		deselect_fish()
