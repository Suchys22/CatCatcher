extends KinematicBody

var hp = 100
var speed = 7

onready var player = get_node("/root/World/Scripts/Player")
onready var attack_anim = get_node("AnimationPlayer")
onready var hitbox = get_node("Hitbox")

func _process(delta):
	if hp <= 0:
		queue_free()
	
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

