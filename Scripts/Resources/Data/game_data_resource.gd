class_name GameDataResource
extends Resource

@export var money: float = 0.0
@export var owned_aquariums: Array[AquariumResource] = []
@export var current_aquarium: AquariumResource
@export var purchased_global_upgrades: Array[String] = []
@export var last_save_timestamp: int = 0
