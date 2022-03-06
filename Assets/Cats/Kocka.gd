extends KinematicBody

var hp = 100

var speed = 2

var direction = Vector3()
var velocity = Vector3()
var movement = Vector3()

func _physics_process(delta: float) -> void:
	if hp <= 0: # Mrtev
		queue_free()
		
#	else:
#		direction = Vector3(random(), -2, random())
#		velocity = velocity.linear_interpolate(direction * speed, delta)
#
#		move_and_slide(velocity)


func random():
	randomize()
	return randi() %21 - 10 # range is -10 to 10
