extends Node3D


func _physics_process(delta: float) -> void:
	%Cube.rotation.y += delta * PI/2
