extends TextureProgress

onready var player = get_node("/root/World/Scripts/Player")

# Bars
onready var hp_bar = get_node("/root/World/Hud/HP/Progress")
onready var stamina_bar = get_node("/root/World/Hud/Stamina/Progress")

func _process(delta):
	var hp = player.get("hp")
	hp_bar.value = hp
	
	var stamina = player.get("stamina")
	stamina_bar.value = stamina
