extends TextureProgress

onready var player = get_node("/root/World/Scripts/Player")

# Bars
onready var hp_bar = get_node("/root/World/Hud/HP/Progress")
onready var stamina_bar = get_node("/root/World/Hud/Stamina/Progress")
onready var backpack_bar = get_node("/root/World/Hud/Backpack/Progress")

func _process(delta):
	var hp = player.get("hp")
	hp_bar.value = hp
	
	var stamina = player.get("stamina")
	stamina_bar.value = stamina
	
	var back_pocet = player.get("backpack_pocet")
	var back_max = player.get("backpack_max")
	backpack_bar.value = back_pocet
	backpack_bar.max_value = back_max
