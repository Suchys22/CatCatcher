# global_transform.origin = globalní pozice (V Worldu) 
# translation = pozice v Navigation

extends KinematicBody

signal hp_changed(hp)
signal stamina_changed(stamina)
signal backpack_changed(pocet, maximum)
signal shop_data_changed(penize, nasobicc)
signal save_game(data)

var speed

var nasobic = 1

export var hp = {
	"hp": 100,
	"maximum": 100,
}

export var stamina = {
	"stamina": 100,
	"max_": 100,
}

export var move_speed: float
export var crouch_speed: float

export var mouse_sense = 0.1

export var damage: float
export var double_jump: bool = false

export var backpack = {
	"pocet": 0,
	"max": 2,
}

const ACCEL_DEFAULT = 7
const ACCEL_AIR = 1
onready var accel = ACCEL_DEFAULT
var gravity = 9.8
var jump = 5

var cam_accel = 40
var snap

var attacked = false
var hp_regen = false

var stand_height = 1.5
var crouch_height = .5

var jumped = 1

var menu = false
var in_shop = false

var head_bonked = false

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

export(NodePath) var shop_node
onready var shop = get_node(shop_node)

func _ready():
	#curzor pápá
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	#myška
	if event is InputEventMouseMotion && !menu:
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
	if event.is_action_pressed("escape") && !in_shop:
		menu = not menu
		pause(menu)
	if event.is_action_pressed("lmb"):
		attack()
		
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST or what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		var data = {
			"hp": hp,
			"stamina": stamina,
			"backpack": backpack,
			"penize": shop.penezenka,
			"nasobic": nasobic,
			"double_j": double_jump
		}
		
		emit_signal("save_game", data)

func _on_World_send_data(data) -> void:
#	hp = {"hp": 100, "maximum": 200}#	
	hp = data.hp
	stamina = data.stamina
	backpack.pocet = data.backpack.pocet
	backpack.max = data.backpack.max
	nasobic = data.nasobic
	double_jump = data.double_j
	emit_signal("hp_changed", hp)
	emit_signal("stamina_changed", stamina)
	emit_signal("backpack_changed", backpack.pocet, backpack.max)
	emit_signal("shop_data_changed", data.penize, nasobic)
		
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
				if body.hp == 0 && backpack.pocet < backpack.max:
					backpack.pocet+=1
					emit_signal("backpack_changed", backpack.pocet, backpack.max)
					

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
			
	# Double jump
	if jumped == 2 && is_on_floor():
		jumped = 1
		
	if Input.is_action_just_pressed("jump") && is_on_floor():
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
	elif double_jump && Input.is_action_just_pressed("jump") && jumped < 2:
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
		jumped +=1
		print("Skacuuu")
	
	
	if !menu:
		move_and_slide_with_snap(movement, snap, Vector3.UP)
		speed = move_speed
	
	# Run
	if Input.is_action_pressed("run") && stamina.stamina > .1 && velocity > Vector3(0.7, 0.7, 0.7):
		speed = 14
		stamina.stamina-= .5
		emit_signal("stamina_changed", stamina)
	else:
		speed = 7
		
		
	# Regen staminy	
	if speed == 7 && stamina.stamina < 100:
		stamina.stamina+=.1
		emit_signal("stamina_changed", stamina)
		
	if !attacked && !hp_regen:
		hp_regen = false
		$HPRegen.wait_time= 5
		$HPRegen.start()
		
	# Regen hp	
	if hp_regen && hp.hp < hp.maximum:
		emit_signal("hp_changed", hp)
		hp.hp += .1
		

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


func _on_Shop_shop_changed(nasobicc) -> void:
	nasobic = nasobicc


func _on_Shop_hp_changed(hpp) -> void:
	hp = hpp
	emit_signal("hp_changed", hpp)

func _on_Shop_ui_changed(state) -> void:
	pause(state) # kursor
	in_shop = state
	menu = state # pohled kamery

func _on_HPRegen_timeout() -> void:
	hp_regen = true
