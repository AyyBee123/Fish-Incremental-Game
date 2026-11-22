class_name Aquarium
extends Node3D

var aquarium_res: AquariumResource

@onready var ui: Control = %UI
@onready var camera: Camera3D = %Camera3D
@onready var fish_manager: Node = %"Fish Manager"
@onready var click_manager: Node = %"Click Manager"

var selected_fish: Fish
var displayed_money: float:
	set(v):
		displayed_money = v
		%MoneyLabel.text = "$%.2f" % v


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


func switch_aquarium(new_aquarium: AquariumResource) -> void:
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
	
	if is_instance_valid(selected_fish):
		selected_fish.set_selected(false)
	
	selected_fish = fish
	selected_fish.set_selected(true)
	
	


func deselect_fish() -> void:
	if is_instance_valid(selected_fish):
		selected_fish.set_selected(false)
	
	selected_fish = null


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click") or event.is_action_pressed("back"):
		deselect_fish()
