extends Node3D

@onready var fish: Fish = get_parent()


func _physics_process(_delta: float) -> void:
	rotation.z = -fish.rotation.z
