extends Spatial

var metoda = "Scene"
export(int) var pocet_spawn
export(int) var max_spawn
export(int) var sek_na_spawn

export(PackedScene) var model
export(NodePath) var navMesh_node

var spawned = 0
onready var timer = $Spawn

func _ready() -> void:
	timer.wait_time = sek_na_spawn
	
	if model != null:
		print("Scéna vypada, ze je dobra")
		timer.start()
	else:
		print("A co, ze chces spawnout?")
				

func _on_Spawn_timeout() -> void:
	if pocet_spawn > 0:
		var need = max_spawn - spawned

		#15 2x/2s
#		print("Pocet: %d, Potreba: %d, Spawned: %d, Max: %d" % [pocet_spawn, need, spawned, max_spawn])
		if need <= max_spawn:
			for j in range(need):
				var cat = model.instance()
				get_node(navMesh_node).add_child(cat)
				cat.translation = translation
				cat.scale = Vector3(.05, .26, .05)
				cat.connect("killed", self, "_on_Kocka_killed")
				spawned+=1
				print("+1 | ", spawned)


func _on_Kocka_killed() -> void:
	spawned -= 1
	print("-1 | ", spawned)
