class_name Aquarium
extends Node3D

@export var aquarium_res: AquariumResource

@onready var ui: Control = %UI
@onready var camera: Camera3D = %Camera3D
@onready var fish_manager: Node = %"Fish Manager"
@onready var click_manager: Node = %"Click Manager"

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
		owned_aquariums.append(aquarium_res)
		if owned_aquariums.size() > 1:
			aquarium_res.aquarium_name = "Aquarium %s" % (owned_aquariums.size())
	
	if aquarium_res.fish.is_empty():
		# new aquarium
		fish_manager.spawn_fish(fish_manager.create_fish(Preloads.CLOWNFISH, fish_manager.fish_names.pick_random()), true)
	else:
		# spawn fish assigned to this aquarium
		for fish_data in aquarium_res.fish:
			fish_manager.spawn_fish(fish_data.fish, false, false, fish_data.position, fish_data.rotation)


func _process(delta: float) -> void:
	if displayed_money != SaveManager.game_data.money:
		displayed_money = lerpf(displayed_money, SaveManager.game_data.money, 1.0 - exp(-25.0 * delta))
