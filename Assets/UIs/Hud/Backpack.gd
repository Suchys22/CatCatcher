extends TextureRect

func _on_Player_backpack_changed(pocet, maximum) -> void:
	$Progress.value = pocet
	$Progress.max_value = maximum
	
	$Pocet.text = "%d/%d" % [pocet, maximum]


func _on_Shop_selled(pocet, max_, money) -> void:
	$Progress.value = pocet
	$Pocet.text = "%d/%d" % [pocet, max_]
	$Sell/Label.text = "$%d" % money
