extends Node

func _init() -> void:
	var node = preload("res://Assets/Cats/Kocka.tscn")
	
	for i in range(1, 15):
		var cat = node.instance()
		add_child(cat)
		cat.global_transform.origin = Vector3(1033.46, 0, 1046.484)
		cat.scale = Vector3(.293, .295, .3)
