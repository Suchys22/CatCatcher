extends KinematicBody

var hp = 100
var speed = 7

var path = []
var path_node = 0

var direction = Vector3()
var velocity = Vector3()
var movement = Vector3()

onready var nav = get_node("/root/World/Navigation")

onready var player = get_node("/root/World/Navigation/NavMesh/Scripts/Player")
onready var attack_anim = get_node("AnimationPlayer")
onready var hitbox = get_node("Hitbox")
onready var time = get_node("Timer")

func _physics_process(delta):
	if hp <= 0:
		queue_free()
	
	if hp > 0:
		if path_node < path.size():
			var direction = (path[path_node] - global_transform.origin)
			if direction.length() < 1:
				path_node+=1
			else:
				look_at(player.global_transform.origin, Vector3.UP)
				move_and_slide(direction.normalized() * speed, Vector3.DOWN)
				
func move_to(pos):
	path = nav.get_simple_path(global_transform.origin, pos)
	path_node = 0


func _on_See_body_entered(body):
	move_to(player.global_transform.origin)
	time.paused = false

func _on_Timer_timeout():
	move_to(player.global_transform.origin)


#func _process(delta):
	
#	if hp > 0:
#		for body in hitbox.get_overlapping_bodies():
#			if body.is_in_group("Hrac"):
#
#				if not attack_anim.is_playing():
#					attack_anim.play("Attack")
#					attack_anim.queue("Return")
#
#				if attack_anim.current_animation == "Attack":
#					body.hp -= 1




