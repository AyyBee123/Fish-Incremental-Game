class_name Fish
extends Node3D

@export var fish_res: FishInstanceResource

@onready var animation_tree: AnimationTree = %AnimationTree
@onready var aquarium: Aquarium = get_tree().current_scene

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
		
		if distance < fish_res.species.arrival_distance:
			has_destination = false
			stop_movement()
		else:
			var direction = global_position.direction_to(target_position)
			target_velocity = direction * fish_res.species.max_speed
	
	var accel = fish_res.species.acceleration
	
	if target_velocity.length() < velocity.length():
		accel = fish_res.species.deceleration
	
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
	var weight = 1.0 - exp(-fish_res.species.rotation_speed * delta)
	
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
	set_target_position(fish_res.species.movement_behaviour.get_next_destination(self))


func get_random_destination() -> Vector3:
	var manager: FishManager = aquarium.fish_manager
	return Vector3(
		randf_range(manager.aquarium_min.x, manager.aquarium_max.x),
		randf_range(manager.aquarium_min.y, manager.aquarium_max.y),
		randf_range(manager.aquarium_min.z, manager.aquarium_max.z)
	)


func update_animation_parameters() -> void:
	var speed_ratio = clampf(velocity.length() / fish_res.species.max_speed, 0.0, 1.0)
	var blend = lerpf(-1.0, 1.0, speed_ratio)
	animation_tree["parameters/Movement/blend_position"] = blend
