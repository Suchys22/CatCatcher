extends Spatial

enum typy {Normal = 0, Attack = 1}

var metoda = "Scene"
export(int) var pocet_spawn
export(int) var max_spawn
export(int) var sek_na_spawn

export(PackedScene) var model_normal
export(PackedScene) var model_attack

export(NodePath) var navMesh_node

var model
var typ

var spawned = 0

onready var timer = $Spawn

func _ready() -> void:
	timer.wait_time = sek_na_spawn
	
	if model_normal && model_attack != null:
		print("Scény vypadaj, ze jsou dobry")
		timer.start()
	else:
		print("A co, ze chces spawnout?")
				

func _on_Spawn_timeout() -> void:
	var distance_to_spawner: int = get_node("/root/World/Navigation/NavigationMeshInstance/Spawner").global_transform.origin.distance_to(get_node("/root/World/Navigation/NavigationMeshInstance/Player").global_transform.origin)
	if pocet_spawn > 0 && distance_to_spawner < 40:
		var need = max_spawn - spawned
		
		if spawned <= max_spawn && need > pocet_spawn:
			for j in range(pocet_spawn):
				if random() <= 3:
					model = model_attack
				else:
					model = model_normal
				
				var cat = model.instance()
				get_node(navMesh_node).add_child(cat)
				cat.translation = translation
				match model:
					model_normal:
						cat.scale = Vector3(.05, .26, .05)
					model_attack:
						cat.scale = Vector3(.08, .45, .08)
						cat.connect("player_attacked", self, "_on_Torinka_player_attacked")
					
				cat.connect("killed", self, "_on_Kocka_killed")
				spawned+=1
				
			print("%d/%d" % [spawned, max_spawn])
		elif need > 0:
			for j in range(need):
				if random() <= 3:
					model = model_attack
				else:
					model = model_normal
				var cat = model.instance()
				get_node(navMesh_node).add_child(cat)
				cat.translation = translation
				match model:
					model_normal:
						cat.scale = Vector3(.05, .26, .05)
					model_attack:
						cat.scale = Vector3(.08, .45, .08)
						cat.connect("player_attacked", self, "_on_Torinka_player_attacked")
				cat.connect("killed", self, "_on_Kocka_killed")
				spawned+=1
				
			print("%d/%d" % [spawned, max_spawn])	


func random():
	randomize()
	return randi() % 10
	
func _on_Kocka_killed() -> void:
	spawned -= 1
