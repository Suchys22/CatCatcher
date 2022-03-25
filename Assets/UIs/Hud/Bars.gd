extends TextureProgress


func _on_Player_stamina_changed(stamina) -> void:
	value = stamina.stamina
	max_value = stamina.max_

func _on_Player_hp_changed(hp) -> void:
	max_value = hp.maximum
	value = hp.hp
