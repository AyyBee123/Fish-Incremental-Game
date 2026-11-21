class_name AquariumSelectionButton
extends TextureButton

var aquarium: AquariumResource


func setup(aquarium_resource: AquariumResource) -> void:
	aquarium = aquarium_resource
	%Label.text = aquarium.aquarium_name
