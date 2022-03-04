extends Area

var cena = 10
var penize = 0

onready var player = get_node("../Player")

func _on_Area_area_entered(area):
	var backpack = player.get("backpack_pocet")
	if backpack > 0:
		sell(backpack)
		player.set("backpack_pocet", 0)

func buy(item, price):
	penize-= price
	print("Úspěšně zakoupeno %s za %d$" % [item], [price])

func sell(num):
	penize+= num * cena
	print("Úspěšně prodáno")
	print("Peněženka: ", penize)
	

