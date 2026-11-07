class_name Fish
extends Node3D

@onready var animation_tree: AnimationTree = %AnimationTree
@onready var aquarium: Aquarium = get_tree().current_scene

@export var acceleration: float = 2.0
@export var deceleration: float = 1.0
@export var max_speed: float = 2.0
@export var arrival_distance: float = 0.2
@export var rotation_speed: float = 2.0

var fish_res: FishResource
var velocity: Vector3 = Vector3.ZERO
var target_position: Vector3
var has_destination: bool = false


func _ready() -> void:
	target_position = global_position
	wait()


func _physics_process(delta) -> void:
	var target_velocity = Vector3.ZERO
	
	if has_destination:
		var distance = global_position.distance_to(target_position)
		
		if distance < arrival_distance:
			has_destination = false
			stop_movement()
		else:
			var direction = global_position.direction_to(target_position)
			target_velocity = direction * max_speed
	
	var accel = acceleration
	
	if target_velocity.length() < velocity.length():
		accel = deceleration
	
	velocity = velocity.move_toward(target_velocity, accel * delta)
	global_position += velocity * delta
	
	update_rotation(delta)
	update_animation_parameters()


func update_rotation(delta: float) -> void:
	var direction = velocity.normalized()
	
	if direction.length() < 0.01: return
	
	var target_rotation_y = 0.0
	
	if direction.x < 0.0:
		target_rotation_y = PI
	
	var target_rotation_z = atan2(direction.y, abs(direction.x))
	var weight = 1.0 - exp(-rotation_speed * delta)
	
	rotation.y = lerp_angle(rotation.y, target_rotation_y, weight)
	rotation.z = lerp_angle(rotation.z, target_rotation_z, weight)


func set_target_position(_target_position: Vector3) -> void:
	target_position = _target_position
	has_destination = true


func stop_movement() -> void:
	has_destination = false
	wait()


func wait() -> void:
	await get_tree().create_timer(randf_range(2.0, 6.0)).timeout
	set_target_position(get_random_destination())


func get_random_destination() -> Vector3:
	var manager: FishManager = aquarium.fish_manager
	return Vector3(
		randf_range(manager.aquarium_min.x, manager.aquarium_max.x),
		randf_range(manager.aquarium_min.y, manager.aquarium_max.y),
		randf_range(manager.aquarium_min.z, manager.aquarium_max.z)
	)


func update_animation_parameters() -> void:
	var speed_ratio = clampf(velocity.length() / max_speed, 0.0, 1.0)
	var blend = lerpf(-1.0, 1.0, speed_ratio)
	animation_tree["parameters/Movement/blend_position"] = blend
