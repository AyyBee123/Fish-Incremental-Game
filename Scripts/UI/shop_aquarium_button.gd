class_name ShopAquariumButton
extends TextureButton

var price: float
var image: Texture2D
var aquarium_name: String


func _ready() -> void:
	%PriceLabel.text = "$%s" % Utils.format_number(price)
	%AquariumLabel.text = "Extra " + aquarium_name
