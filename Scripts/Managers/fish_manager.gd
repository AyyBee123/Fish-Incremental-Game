class_name FishManager
extends Node

@export var aquarium_margin_left: float = 4.0
@export var aquarium_margin_right: float = 4.0
@export var aquarium_margin_up: float = 4.0
@export var aquarium_margin_down: float = 4.0

@onready var aquarium: Aquarium = get_tree().current_scene

var aquarium_min: Vector3
var aquarium_max: Vector3

var fish_names: Array = []


func _ready() -> void:
	load_fish_names()
	get_aquarium_bounds()
	for i in 1:
		spawn_fish(create_fish(preload("uid://df20jvqg3ut1w"), fish_names.pick_random()))


func create_fish(species: FishSpeciesResource, fish_name: String = "Fish") -> FishInstanceResource:
	var fish_instance = FishInstanceResource.new()
	fish_instance.species = species
	fish_instance.fish_name = fish_name
	return fish_instance


func spawn_fish(fish_instance: FishInstanceResource, pos: Vector3 = Vector3(randf_range(aquarium_min.x, aquarium_max.x), 0, 0)) -> void:
	var fish: Fish = fish_instance.species.model.instantiate()
	fish.fish_res = fish_instance
	add_child(fish)
	fish.global_position = pos


func get_aquarium_bounds() -> void:
	var corners = [Vector2(0, 0), Vector2(get_viewport().size.x, 0), Vector2(0, get_viewport().size.y), get_viewport().size]
	var positions: Array[Vector3] = []
	var plane = Plane(Vector3.FORWARD, 0)
	
	for corner in corners:
		var origin = aquarium.get_node("%Camera3D").project_ray_origin(corner)
		var direction = aquarium.get_node("%Camera3D").project_ray_normal(corner)
		var intersection = plane.intersects_ray(origin, direction)
		
		if intersection != null:
			positions.append(intersection)
	
	aquarium_min = Vector3(INF, INF, 0)
	aquarium_max = Vector3(-INF, -INF, 0)
	
	for point in positions:
		aquarium_min.x = minf(aquarium_min.x, point.x)
		aquarium_min.y = minf(aquarium_min.y, point.y)
		aquarium_max.x = maxf(aquarium_max.x, point.x)
		aquarium_max.y = maxf(aquarium_max.y, point.y)
	
	aquarium_min.x += aquarium_margin_left
	aquarium_max.x -= aquarium_margin_right
	aquarium_min.y += aquarium_margin_down
	aquarium_max.y -= aquarium_margin_up


func load_fish_names() -> void:
	const PATH: String = "res://Data/fish_names.json"
	var file: FileAccess = FileAccess.open(PATH, FileAccess.READ)
	fish_names = JSON.parse_string(file.get_as_text())
