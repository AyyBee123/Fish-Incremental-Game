class_name ShopFishButton
extends TextureButton

var price: float
var image: Texture2D


func _ready() -> void:
	%PriceLabel.text = "$%d" % price
	%FishImage.texture = image
