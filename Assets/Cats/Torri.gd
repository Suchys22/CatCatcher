# global_transform.origin = globalní pozice (V Worldu) 
# translation = pozice v Navigation

extends KinematicBody

signal killed()
signal player_attacked(state)

export var hp = 100

export var speed = 1.5

var path = []
var path_attack = []

var path_node = 0

var attack: bool = false

var direction = Vector3()
var velocity = Vector3()
var movement = Vector3()

export(Vector3) var Zone = Vector3(-3.591, 0.503, 0.048)
export(NodePath) var navNode
onready var timer = $Timer

onready var player = get_node("../Player")

func _ready() -> void:
	timer.connect("timeout", self, "_on_Despawn_timeout")
	connect("player_attacked", self, "_on_Torinka_player_attacked")

func _physics_process(delta: float) -> void:
	var step_size = delta * speed
	
	if hp <= 0: # Mrtev
		queue_free()
		emit_signal("killed")
	else:

		if path.size() > 0:
			var destination = path[0]
			direction = destination - translation
			
			if step_size > direction.length():
				step_size = direction.length()
				path.remove(0)
			
			translation += direction.normalized() * step_size
			
			rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z), delta + .2)

func _on_Timer_timeout() -> void:
	var nav = get_node("/root/World/Navigation")
	if !attack: # neattakuje
		var target_point = Zone + Vector3(random(), -0.2, random())
		if randi() % 5:
			target_point*= -1
		path = nav.get_simple_path(translation, target_point, true)
	else:
		path = nav.get_simple_path(translation, player.translation)
#		Tween.interpolate_property(self, "rotation", rotation, rotation + Vector3(0, randi() % 90+1, 0), 5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
#		Tween.start()

func random():
	randomize()
	return randi() %9 + 1

func _on_Despawn_timeout():
	var distance: float = global_transform.origin.distance_to(get_node("/root/World/Navigation/NavigationMeshInstance/Player").global_transform.origin)
	if distance > 50:
		queue_free()
		emit_signal("killed")
	
func _on_See_body_entered(body: Node) -> void:
	if body.is_in_group("Hrac"):
		attack = true
		player.set("attacked", true)
		player.set("hp_regen", false)
		print("Utooook")


#func _on_See_body_exited(body: Node) -> void:
#	if body.is_in_group("Hrac"):
#		attack = false
#		player.set("attacked", false)
#		print("Do riti, jsem ho stratil (FiveM PDčka :D)")
