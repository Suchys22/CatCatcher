extends Label

onready var player = get_node("/root/World/Scripts/Player")
onready var shop = get_node("/root/World/Scripts/Sell")

onready var backpack = get_node("/root/World/Hud/Backpack/Pocet")
onready var sell = get_node("/root/World/Hud/Sell")

func _process(delta):
	backpack.text = "%d/%d" % [player.get("backpack_pocet"), player.get("backpack_max")] 
	sell.text = "$%d" % [shop.get("penize")]

