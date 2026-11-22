class_name FishInstanceResource
extends Resource

@export_category("Fish Properties")
@export var species: FishSpeciesResource
@export var fish_name: String

@export_category("Click Properties")
@export var click_increase: float = 0.0
@export var click_multiplier: float = 1.0

@export_category("Miscellaneous Properties")
@export var purchase_timestamp: int = 0

var aquarium_position: Vector3
