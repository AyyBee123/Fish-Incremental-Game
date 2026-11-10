class_name Aquarium
extends Node3D

@onready var camera: Camera3D = %Camera3D
@onready var fish_manager: Node = %"Fish Manager"
@onready var click_manager: Node = %"Click Manager"

var global_click_multiplier: float = 1.0
var money: float
var displayed_money: float:
	set(v):
		displayed_money = v
		%MoneyLabel.text = "$%.2f" % v


func _ready() -> void:
	money = money # for now, until I add a save file for it to read
	displayed_money = money


func _process(delta: float) -> void:
	if displayed_money != money:
		displayed_money = lerpf(displayed_money, money, 1.0 - exp(-25.0 * delta))
