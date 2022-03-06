extends Area

signal selled(backpack, money)

var cena = 10
var penize = 0

onready var player = get_node("../Player")

func _ready() -> void:
	emit_signal("selled", 0, penize)

func _on_Area_area_entered(area):
	var backpack = player.get("backpack_pocet")
	if backpack > 0:
		sell(backpack)

func buy(item, price):
	penize-= price
	print("Úspěšně zakoupeno %s za %d$" % [item], [price])

func sell(num):
	player.set("backpack_pocet", 0)
	penize+= num * cena
	print("Úspěšně prodáno")
	print("Peněženka: $", penize)
	emit_signal("selled", 0, penize)
	

