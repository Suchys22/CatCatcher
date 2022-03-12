extends KinematicBody

signal killed()

export var hp = 100

export var speed = 1.5

var path = []

var direction = Vector3(0, 0, 0)
var velocity = Vector3()
var movement = Vector3()

export(Vector3) var Zone = Vector3(-3.591, 0.503, 0.048)
export(NodePath) var navNode
onready var timer = $Timer
#Vector3(-3.591, 0.753, 0.048)

func _physics_process(delta: float) -> void:
	if hp == 0: # Mrtev
		queue_free()
		emit_signal("killed")
	else:
		var step_size = delta * speed

		if path.size() > 0:
			var destination = path[0]
			direction = destination - translation
			
			if step_size > direction.length():
				step_size = direction.length()
				path.remove(0)
			
			translation += direction.normalized() * step_size
			
			rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), delta + .2)

func _on_Timer_timeout() -> void:
	var nav = get_node("/root/World/Navigation")
	var target_point = Zone + Vector3(random(), -0.2, random())
	if randi() % 5:
		target_point*= -1
	path = nav.get_simple_path(translation, target_point, true)
	timer.stop()

func random():
	randomize()
	return randi() %9 + 1

#func _on_See_body_entered(body: Node) -> void:
#	if body.is_in_group("Hrac"):
#		attack = true
#		look_at(body.global_transform.origin, Vector3.UP)
