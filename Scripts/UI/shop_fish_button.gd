class_name ShopFishButton
extends TextureButton

var price: float
var image: Texture2D
var fish_name: String


func _ready() -> void:
	%PriceLabel.text = "$%s" % Utils.format_number(price)
	%NameLabel.text = fish_name
	%FishImage.texture = image
