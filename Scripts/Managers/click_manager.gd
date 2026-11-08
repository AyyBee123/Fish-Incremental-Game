extends Node

var click_circle: ClickCircle

func _ready() -> void:
	click_circle = Preloads.CLICK_CIRCLE.instantiate()
	add_child(click_circle)
