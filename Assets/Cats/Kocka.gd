extends KinematicBody

var direction = Vector3()
var velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3.UP

var hp = 100

const ACCEL_DEFAULT = 7
var speed = 7

onready var player = get_node("/root/World/Scripts/Player")
onready var cat = load("res://Assets/Cats/Kocka.tscn")

func random():
	randomize()
	return randi() %21 - 10 # range is -10 to 10

func create():
	var enemy = cat.instance()
	enemy.global_transform.origin = Vector3(1031.489, 0, 1046.89)
	get_parent().add_child(enemy)

func _on_Move_timeout():
	if hp > 0:
		direction = Vector3(random(), -2, random())
		velocity = velocity.linear_interpolate(direction * speed, .2)
		movement = velocity + gravity_vec
	
		move_and_slide(movement, Vector3.UP)
	else:
		queue_free()

func _on_See_body_entered(body):
	if hp > 0:
		look_at(player.global_transform.origin, Vector3.UP)

func _on_Spawn_timeout():
#	create()
	print("")
