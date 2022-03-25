extends Navigation

var SPEED = 7

var path = []

var x = 0
var y = 0

export(PackedScene) onready var model

var cats = []

#func _ready() -> void:
#
#	for i in range(1, 15):
#		var kocka = robot.ins
#		get_node("NavigationMeshInstance").add_child(kocka)
#		kocka.global_transform.origin = Vector3(1054.208 + random(), 0.304, 1046.89 + random())
#		kocka.scale = Vector3(.293, .295, .3);
#		x+=1
#		cats.append(kocka)
#
#	print(x)
#
#func _physics_process(delta):
#	for i in range(x):
#		var kocka = cats[i]
#		var direction = Vector3()
#
#		var step_size = delta * SPEED
#
#		if path.size() > 1:
#			var destination = path[1]
#			direction = destination - kocka.translation
#
#			if step_size > direction.length():
#				step_size = direction.length()
#				path.remove(1)
#
#			kocka.translation += direction.normalized() * step_size
#
#			var look_at_point = kocka.translation + direction
#			kocka.look_at(look_at_point, Vector3.UP)
#
#func _on_Timer_timeout() -> void:
#	for i in range(x ):
#		var kocka = cats[i]
#		var target_point = Vector3(0.450 + random() + random(), 0.304, 0.350 + random())
#		path = get_simple_path(kocka.translation, target_point, true)

func random():
	randomize()
	return randi() %21 - 10 # range is -10 to 10
