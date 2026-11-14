extends Control

@export var thickness: float = 3.0
@export var color: Color = Color(0.2, 0.8, 1.0, 0.7)
@export var segments: int = 64

@onready var click_circle: ClickCircle = %"Click Circle"

var radius: float


func _process(_delta: float) -> void:
	var cylinder: CylinderShape3D = click_circle.collision_shape.shape
	var camera: Camera3D = click_circle.aquarium.camera
	
	var center: Vector3 = click_circle.global_position
	var radius_3d: float = cylinder.radius
	
	var screen_center: Vector2 = camera.unproject_position(center)
	var screen_edge: Vector2 = camera.unproject_position(click_circle.to_global(Vector3(radius_3d, 0.0, 0.0)))
	
	position = screen_center
	radius = screen_center.distance_to(screen_edge)
	
	queue_redraw()


func _draw() -> void:
	draw_arc(Vector2.ZERO, radius, 0.0, TAU, segments, color, thickness, true)
