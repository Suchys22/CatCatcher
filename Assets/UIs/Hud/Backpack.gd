extends TextureRect

func _on_Player_backpack_changed(pocet, maximum) -> void:
	$Progress.value = pocet
	$Progress.max_value = maximum
	
	$Pocet.text = "%d/%d" % [pocet, maximum]


func _on_Sell_selled(backpack, money) -> void:
	$Progress.value = backpack
	$Sell/Label.text = "$%d" % money
