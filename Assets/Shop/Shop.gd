extends Spatial

signal ui_changed(state)
signal selled(pocet, max_, money)
signal shop_changed(nasobicc)
signal hp_changed(hp)

export var Products = {
	# HP
	"125HP": 10,
	"150HP": 15,
	"200HP": 20,
	
	# Double
	"DoubleJump": 40,
	
	# Site
	"Sit1": 10,
	"Sit2": 15,
	"Sit3": 20,
	
	# Nasobiče
	"x2": 40,
	"x4": 60,
	"x6": 80,
}

export var penezenka: float
export var cena = 10 # Za kocku
export(int) var nasobic
export(NodePath) var player_node

export(NodePath) var zakladni_sit
export(NodePath) var advanced_sit
export(NodePath) var expert_sit

onready var player = get_node(player_node)
		
func _on_Sell_body_entered(body: Node) -> void:
	if body.is_in_group("Hrac"):
		var back = body.backpack.pocet
		if back > 0:
			sell(back, body)
		else:
			print("Ty šašku, vždyt nemáš žádný kočky...")

func sell(num, player):
	player.backpack.pocet = 0
	penezenka += num * cena * nasobic
	print("Úspěšně prodáno")
	print("Peněženka: $ %d (+%.1f (%dx)) " % [penezenka, num * cena * nasobic, nasobic])
	emit_signal("selled", player.backpack.pocet, player.backpack.max, penezenka)
	

func _on_Player_shop_data_changed(penize, nasobicc) -> void:
	penezenka = penize
	nasobic = nasobicc
	emit_signal("selled", player.backpack.pocet, player.backpack.max, penize)
		
func _on_Area_body_entered(body: Node) -> void:
	if body.is_in_group("Hrac"):
		print("Otevíram shop")
		emit_signal("ui_changed", true)

func _on_Area_body_exited(body: Node) -> void:
	if body.is_in_group("Hrac"):
		print("Zavíram shop")
		emit_signal("ui_changed", false)
	
func _on_Shop_buy_request(item) -> void:
	if Products.has(item): # Jestli si tam ten item vubec napsal
		if penezenka >= Products.get(item): # nejses chudy
			if "x" in item: # nasobice
				for i in range(Products.size()):
					if item == Products.keys()[i]:
						nasobic = Products.keys()[i].to_int()
						player.set("nasobic", nasobic)
						print("Nákup úspešne dokončen.")
						print("Koupil jsi: x", nasobic)
				
			elif "HP" in item: # hp
				for i in range(Products.size()):
					if item == Products.keys()[i]:
						var hp = player.get("hp")
						hp.maximum = Products.keys()[i].to_int()
						emit_signal("hp_changed", hp)
						print("Nákup úspešne dokončen.")
						print("Koupil jsi: HP", Products.keys()[i].to_int())
				
			elif item == "DoubleJump":
				player.set("double_jump", true)
				print("Nákup úspešne dokončen.")
				print("Koupil jsi: Double Jump")
				
			elif "Sit" in item:
				if item == "Sit1":
					var wep = get_node(zakladni_sit)
					wep.visible = false
					
					wep = get_node(advanced_sit)
					wep.visible = true
					
				
				
			else: # nekde chyba v syntax
				print("Hm, tak to jsem nenasel")
		else: # chudy
			print("Tak na to hned zapomen")
	else: # pridej to tam a rychle
		print(":DDDD tohle chces koupit? Tak to nemam (%s)" % item)


