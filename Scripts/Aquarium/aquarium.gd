class_name Aquarium
extends Node3D

@onready var camera: Camera3D = %Camera3D
@onready var fish_manager: Node = %"Fish Manager"
@onready var click_manager: Node = %"Click Manager"

var money: float
var global_click_multiplier: float = 1.0
