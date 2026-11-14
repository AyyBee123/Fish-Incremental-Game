class_name ClickCircle
extends Area3D

@onready var aquarium: Aquarium = get_tree().current_scene
@onready var collision_shape: CollisionShape3D = %CollisionShape3D
@onready var click_interval: Timer = %ClickInterval


func _process(_delta: float) -> void:
	update_cursor_position()


func update_cursor_position() -> void:
	var mouse_position = get_viewport().get_mouse_position()
	
	var ray_origin = aquarium.camera.project_ray_origin(mouse_position)
	var ray_direction = aquarium.camera.project_ray_normal(mouse_position)
	
	var aquarium_plane = Plane(Vector3(0, 0, 1), 0.0)
	var intersection = aquarium_plane.intersects_ray(ray_origin, ray_direction)
	
	if intersection != null:
		global_position = intersection
		look_at(intersection + ray_direction, Vector3.UP)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and click_interval.is_stopped():
		var overlapping_fish = get_overlapping_areas()
		if overlapping_fish.is_empty(): return
		click_interval.start()
		for fish in overlapping_fish:
			fish.get_parent().on_click()
