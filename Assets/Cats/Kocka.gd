extends KinematicBody

var hp = 100
var speed = 7

var attacked = false

onready var nav = "../NavigationMeshInstance"

var path = []
var path_node = 0

onready var player = get_node("/root/World/Scripts/Player")

func _process(delta):
	if hp <= 0:
		queue_free()
#
#
#func _physics_process(delta):
#	if hp <= 0:
#		queue_free()
#	else:
#		if path_node < path.size():
#			var direction = (path[path_node] - global_transform.origin)
#			if direction.lenght() < 1:
#				path_node += 1
#			else:
#				move_and_slide(direction.normalized() * speed, Vector3.UP)
#
#func move_to(pos):
#	path = nav.get_simple_path(global_transform.origin, pos)
#	path_node = 0
#
#
#func _on_Timer_timeout():
#	move_to(player.global_transform.origin)
