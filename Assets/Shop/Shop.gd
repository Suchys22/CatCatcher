extends Area

signal selled(backpack, money)

export var penezenka = 0
export var cena = 10 # Za kocku
export(NodePath) var player_node

onready var player = get_node(player_node)

func _ready() -> void:
	emit_signal("selled", 0, penezenka)

func _on_Area_body_entered(body: Node) -> void:
	if body.is_in_group("Hrac"):
		var back = body.backpack.pocet
		if back > 0:
			sell(back, body)
		else:
			print("Ty šašku, vždyt nemáš žádný kočky...")
	
func buy(item, price):
	penezenka-= price
	print("Úspěšně zakoupeno %s za %d$" % [item], [price])

func sell(num, player):
	player.backpack.pocet = 0
	penezenka+= num * cena
	print("Úspěšně prodáno")
	print("Peněženka: $", penezenka)
	emit_signal("selled", 0, penezenka)
	



