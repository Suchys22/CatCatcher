extends TextureProgress


func _on_Player_stamina_changed(stamina) -> void:
	value = stamina

func _on_Player_hp_changed(hp) -> void:
	value = hp
