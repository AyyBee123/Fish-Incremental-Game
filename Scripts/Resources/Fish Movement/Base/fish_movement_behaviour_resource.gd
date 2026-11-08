class_name MovementBehaviour
extends Resource


func get_next_destination(fish: Fish) -> Vector3:
	return fish.get_random_destination()
