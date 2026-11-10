class_name FishSpeciesResource
extends Resource

@export_category("Core")
@export var species_name: String
@export var model: PackedScene

@export_category("Movement")
@export var movement_behaviour: MovementBehaviour
@export var acceleration: float = 2.0
@export var deceleration: float = 1.0
@export var max_speed: float = 2.0
@export var arrival_distance: float = 0.2
@export var rotation_speed: float = 1.5

@export_category("Click")
@export var click_value: float = 1.0
@export var click_increase: float = 0.0
@export var click_multiplier: float = 1.0
