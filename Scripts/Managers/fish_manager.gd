class_name FishManager
extends Node

@export var aquarium_min: Vector3
@export var aquarium_max: Vector3

var fish_names: Array = []


func _ready() -> void:
	load_fish_names()
	spawn_fish(create_fish(preload("uid://df20jvqg3ut1w"), fish_names.pick_random()))


func create_fish(species: FishSpeciesResource, fish_name: String = "Fish") -> FishInstanceResource:
	var fish_instance = FishInstanceResource.new()
	
	fish_instance.species = species
	fish_instance.fish_name = fish_name
	
	return fish_instance


func spawn_fish(fish_instance: FishInstanceResource, pos: Vector3 = Vector3(randf_range(aquarium_min.x, aquarium_max.x), 0, 0)) -> void:
	var fish: Fish = fish_instance.species.model.instantiate()
	fish.fish_res = fish_instance
	get_tree().current_scene.add_child.call_deferred(fish)
	fish.position = pos


func load_fish_names() -> void:
	const PATH: String = "res://Data/fish_names.json"
	var file: FileAccess = FileAccess.open(PATH, FileAccess.READ)
	fish_names = JSON.parse_string(file.get_as_text())
