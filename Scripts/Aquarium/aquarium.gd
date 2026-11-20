class_name Aquarium
extends Node3D

@export var aquarium_res: AquariumResource

@onready var camera: Camera3D = %Camera3D
@onready var fish_manager: Node = %"Fish Manager"
@onready var click_manager: Node = %"Click Manager"

var global_click_multiplier: float = 1.0
var displayed_money: float:
	set(v):
		displayed_money = v
		%MoneyLabel.text = "$%.2f" % v


func _ready() -> void:
	GameManager.current_aquarium = aquarium_res
	displayed_money = GameManager.money
	
	if not GameManager.owned_aquariums.has(aquarium_res):
		GameManager.owned_aquariums.append(aquarium_res)
	
	if aquarium_res.fish.is_empty():
		# new aquarium
		fish_manager.spawn_fish(fish_manager.create_fish(preload("uid://df20jvqg3ut1w")), true)
	else:
		# spawn fish assigned to this aquarium
		for fish_data in aquarium_res.fish:
			fish_manager.spawn_fish(fish_data.fish, false, false, fish_data.position)


func _process(delta: float) -> void:
	if displayed_money != GameManager.money:
		displayed_money = lerpf(displayed_money, GameManager.money, 1.0 - exp(-25.0 * delta))
