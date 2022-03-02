extends KinematicBody

var hp = 100

func _ready():
	pass

func _process(delta):
	if hp <= 0:
		queue_free()
