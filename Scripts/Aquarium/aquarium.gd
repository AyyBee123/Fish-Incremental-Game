class_name Aquarium
extends Node3D

@onready var camera: Camera3D = %Camera3D
@onready var fish_manager: Node = %"Fish Manager"
@onready var click_manager: Node = %"Click Manager"

var global_click_multiplier: float = 1.0
var displayed_money: float:
	set(v):
		displayed_money = v
		%MoneyLabel.text = "$%.2f" % v


func _ready() -> void:
	displayed_money = GameManager.money


func _process(delta: float) -> void:
	if displayed_money != GameManager.money:
		displayed_money = lerpf(displayed_money, GameManager.money, 1.0 - exp(-25.0 * delta))
