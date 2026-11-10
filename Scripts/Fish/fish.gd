class_name Fish
extends Node3D

@export var fish_res: FishInstanceResource

@onready var animation_tree: AnimationTree = %AnimationTree
@onready var aquarium: Aquarium = get_tree().current_scene
@onready var body: Node3D = %Armature

var original_scale: Vector3
var click_tween: Tween
var velocity: Vector3 = Vector3.ZERO
var target_position: Vector3
var wait_id: int = 0
var has_destination: bool = false
var is_spawning: bool = false


func _ready() -> void:
	original_scale = body.scale
	animation_tree["parameters/Movement/blend_position"] = -1.0
	target_position = global_position
	wait()


func _physics_process(delta) -> void:
	if is_spawning: return
	
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


func on_click() -> void:
	if is_spawning: return
	var value = get_click_value()
	aquarium.money += value
	trigger_click_behaviour()


func get_click_value() -> float:
	var base_value = fish_res.species.click_value
	
	var species_increase = fish_res.species.click_increase
	var species_multiplier = fish_res.species.click_multiplier
	
	var individual_increase = fish_res.click_increase
	var individual_multiplier = fish_res.click_multiplier
	
	var global_multiplier = aquarium.global_click_multiplier
	
	return (base_value) \
		* (1.0 + species_increase + individual_increase) \
		* species_multiplier * individual_multiplier \
		* global_multiplier


func trigger_click_behaviour() -> void:
	if click_tween and click_tween.is_running():
		click_tween.kill()
	
	body.scale = original_scale
	
	click_tween = create_tween()
	click_tween.tween_property(body, "scale", original_scale * 0.85, 0.04).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	click_tween.tween_property(body, "scale", original_scale * 1.12, 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	click_tween.tween_property(body, "scale", original_scale, 0.12).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)


func set_target_position(_target_position: Vector3) -> void:
	target_position = _target_position
	has_destination = true


func stop_movement() -> void:
	has_destination = false
	wait()


func wait() -> void:
	wait_id += 1
	var current_wait_id = wait_id
	
	await get_tree().create_timer(randf_range(0.0, 5.0)).timeout
	
	# prevent multiple wait values from fighting each other
	if current_wait_id != wait_id:
		return
	
	if is_spawning:
		return
	
	set_target_position(fish_res.species.movement_behaviour.get_next_destination(self))


func get_random_destination() -> Vector3:
	var manager: FishManager = aquarium.fish_manager
	return Vector3(
		randf_range(manager.aquarium_min.x, manager.aquarium_max.x),
		randf_range(manager.aquarium_min.y, manager.aquarium_max.y),
		randf_range(manager.aquarium_min.z, manager.aquarium_max.z)
	)


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


func play_spawn_animation() -> void:
	is_spawning = true
	velocity = Vector3.ZERO
	has_destination = false
	
	var fish_manager: FishManager = aquarium.get_node("%Fish Manager")
	var center = (fish_manager.aquarium_min.x + fish_manager.aquarium_max.x) / 2.0
	rotation.y = 0.0 if global_position.x < center else PI
	
	var pos = global_position + Vector3(0, randf_range(-10.0, 10.0), 0)
	global_position.y += 30.0
	
	var playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
	playback.travel("Spawn")
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", pos, 2.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	
	is_spawning = false
	playback.travel("Movement")
	wait()


func update_animation_parameters() -> void:
	var speed_ratio = clampf(velocity.length() / fish_res.species.max_speed, 0.0, 1.0)
	var blend = lerpf(-1.0, 1.0, speed_ratio)
	animation_tree["parameters/Movement/blend_position"] = blend
