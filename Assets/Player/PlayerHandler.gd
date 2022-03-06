extends KinematicBody

signal hp_changed(hp)
signal stamina_changed(stamina)
signal backpack_changed(pocet, maximum)

var speed

var move_speed = 7
var crouch_speed = 4

var damage = 50

const ACCEL_DEFAULT = 7
const ACCEL_AIR = 1
onready var accel = ACCEL_DEFAULT
var gravity = 9.8
var jump = 5

var cam_accel = 40
var mouse_sense = 0.1
var snap

var stand_height = 1.5
var crouch_height = .5

var hp = 100
var stamina = 100

var backpack_pocet = 0
var backpack_max = 2

var menu = false

onready var sell = get_node("/root/World/Scripts/Sell")

var head_bonked = false

onready var wait = $stamT

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()
var fall = Vector3()

onready var head = $Head
onready var camera = $Head/Camera
onready var capsule = $CollisionShape

onready var bonker = $HeadBonker

onready var melee_anim = $AnimationPlayer
onready var hitbox = $Head/Camera/Hitbox

func _ready():
	#curzor pápá
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	emit_signal("hp_changed", hp)
	emit_signal("backpack_changed", backpack_pocet,backpack_max)

func _input(event):
	#myška
	if event is InputEventMouseMotion && !menu:
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
	if event.is_action_pressed("escape"):
		menu = not menu
		pause(menu)
	if event.is_action_pressed("lmb"):
		attack()
		
		
func pause(state: bool):
	match state:
		true:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func attack():
	if not melee_anim.is_playing():
		melee_anim.play("Attack")
		melee_anim.queue("Return")
			
	if melee_anim.current_animation == "Attack":
		for body in hitbox.get_overlapping_bodies():
			if body.is_in_group("Kocky"):
				body.hp -= damage
				if body.hp == 0 && backpack_pocet < backpack_max:
					backpack_pocet+=1
					emit_signal("backpack_changed", backpack_pocet,backpack_max)
				else:
					print("Jsi plnej.")

func _process(delta):
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		camera.set_as_toplevel(true)
		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.set_as_toplevel(false)
		camera.global_transform = head.global_transform
	
func _physics_process(delta):
	#klaveska
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
		
	#skok a hop
	if is_on_floor():
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * gravity * delta
			
	if Input.is_action_just_pressed("jump") and is_on_floor():
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
	
	move_and_slide_with_snap(movement, snap, Vector3.UP)
	speed = move_speed
	
	# Run
	if Input.is_action_pressed("run") && stamina > .1:
		speed = 14
		stamina-= .5
		emit_signal("stamina_changed", stamina)
	else: 
		speed = 7
		
	if speed == 7:
		wait
		stamina+=.1
		emit_signal("stamina_changed", stamina)

	# Čupění
	if bonker.is_colliding():
		head_bonked = true
			
	if head_bonked:
		fall.y-=2
			
	if Input.is_action_pressed("crouch"):
		capsule.shape.height -= crouch_speed * delta
		speed = crouch_speed
	elif !head_bonked:
		capsule.shape.height += crouch_speed * delta
		
	capsule.shape.height = clamp(capsule.shape.height, crouch_height, stand_height)
	
	
	#move it more
	if !menu:
		velocity = velocity.linear_interpolate(direction * speed, accel * delta)
		movement = velocity + gravity_vec
