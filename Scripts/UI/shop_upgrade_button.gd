class_name ShopUpgradeButton
extends TextureButton

var price: float
var image: Texture2D
var upgrade_name: String


func _ready() -> void:
	%PriceLabel.text = "$%s" % Utils.format_number(price)
	%UpgradeLabel.text = upgrade_name
	#%UpgradeImage.texture = image
