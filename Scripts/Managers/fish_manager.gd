class_name FishManager
extends Node

@export var aquarium: Aquarium
@export var aquarium_margin_left: float = 4.0
@export var aquarium_margin_right: float = 4.0
@export var aquarium_margin_up: float = 4.0
@export var aquarium_margin_down: float = 4.0


var aquarium_min: Vector3
var aquarium_max: Vector3
var aquarium_cap: int = 100

var fish_names: Array = []


func _ready() -> void:
	load_fish_names()
	set_aquarium_bounds()


func create_fish(species: FishSpeciesResource, fish_name: String = "Fish") -> FishInstanceResource:
	var fish_instance = FishInstanceResource.new()
	fish_instance.species = species
	fish_instance.fish_name = fish_name
	return fish_instance


func spawn_fish(fish_instance: FishInstanceResource, play_anim: bool, is_new: bool = true, pos: Vector3 = Vector3(INF, INF, INF), rot: Vector3 = Vector3(INF, INF, INF)) -> void:
	var fish: Fish = fish_instance.species.model.instantiate()
	fish.fish_res = fish_instance
	
	add_child(fish)
	
	if pos == Vector3(INF, INF, INF):
		fish.global_position = get_random_aquarium_position()
	else:
		fish.global_position = pos
	
	if rot != Vector3(INF, INF, INF):
		fish.global_rotation = rot
	
	if is_new:
		GameManager.add_fish_to_aquarium(fish_instance, aquarium.aquarium_res, fish.global_position)
	
	if play_anim:
		fish.play_spawn_animation()


#func move_fish_to_aquarium(fish_instance: FishInstanceResource, aquarium_res: AquariumResource) -> void:
	#pass


func set_aquarium_bounds() -> void:
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


func get_random_aquarium_position() -> Vector3:
	return Vector3(randf_range(aquarium_min.x, aquarium_max.x), 0, randi_range(-4, 8))


func load_fish_names() -> void:
	const PATH: String = "res://Data/fish_names.json"
	var file: FileAccess = FileAccess.open(PATH, FileAccess.READ)
	fish_names = JSON.parse_string(file.get_as_text())
