class_name ShopCapacityButton
extends TextureButton

var price: float
var image: Texture2D
var capacity_increase: int


func _ready() -> void:
	%PriceLabel.text = "$%s" % Utils.format_number(price)
	%CapacityLabel.text = "Extra Capacity +%d" % capacity_increase
