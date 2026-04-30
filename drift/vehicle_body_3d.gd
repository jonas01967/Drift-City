extends VehicleBody3D

@export var max_engine_force: float = 4000.0
@export var max_reverse_force: float = 2000.0
@export var max_steering_angle: float = 0.35
@export var brake_force: float = 800.0
@export var steering_smooth: float = 8.0
@export var min_steering_ratio: float = 0.35
@export var steering_speed_threshold: float = 20.0
@export var max_roll_rate: float = 1.2
@export var center_of_mass_offset: Vector3 = Vector3(0, -0.2, 0)
@export var angular_dampening: float = 1.0
@export var linear_dampening: float = 0.15

@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var wheel_fl: VehicleWheel3D = $"VehicleWheel3D FL"
@onready var wheel_fr: VehicleWheel3D = $"VehicleWheel3D FR"
@onready var wheel_rl: VehicleWheel3D = $"VehicleWheel3D RL"
@onready var wheel_rr: VehicleWheel3D = $"VehicleWheel3D RR"

var wheel_roll_angle := {
	"VehicleWheel3D FL": 0.0,
	"VehicleWheel3D FR": 0.0,
	"VehicleWheel3D RL": 0.0,
	"VehicleWheel3D RR": 0.0
}

var camera_rotation_y: float = 0.0
var camera_rotation_x: float = -0.3

func _physics_process(delta):
	var target_steering: float = 0.0
	engine_force = 0.0
	brake = 0.0

	if Input.is_action_pressed("ui_up"):
		engine_force = max_engine_force
		brake = 0.0
	elif Input.is_action_pressed("ui_down"):
		engine_force = -max_reverse_force
		brake = 0.0
	else:
		engine_force = 0.0
		brake = 0.0

	# Steering input: left should be negative, right positive in Godot VehicleBody3D
	if Input.is_action_pressed("ui_right"):
		target_steering = -max_steering_angle
	elif Input.is_action_pressed("ui_left"):
		target_steering = max_steering_angle

	# Reduce steering aggressiveness at low speed to avoid sudden jumps
	var speed = linear_velocity.length()
	var steer_ratio = clamp(speed / steering_speed_threshold, min_steering_ratio, 1.0)
	target_steering *= steer_ratio

	# Reduce engine power while turning sharply (more stable dynamics)
	var turn_penalty = abs(target_steering) / max_steering_angle
	engine_force *= lerp(1.0, 0.55, turn_penalty)

	steering = lerp(steering, target_steering, clamp(steering_smooth * delta, 0.0, 1.0))

	# Standstill steering assistance and yaw coupling
	if linear_velocity.length() < 1.0 and abs(target_steering) > 0.01:
		apply_torque_impulse(Vector3.UP * target_steering * 12.0)

	# At speed, keep yaw from excessive side-slip using drift damping
	if linear_velocity.length() > 2.0 and abs(target_steering) > 0.05:
		var local_velocity = transform.basis.inverse() * linear_velocity
		var lateral = local_velocity.x
		apply_central_impulse(transform.basis.x * -lateral * 0.4)

	_update_wheel_mesh_rotation(delta)

	# Prevent runaway roll angular velocity (car falling over mid-steer)
	var av = angular_velocity
	av.x = clamp(av.x, -max_roll_rate, max_roll_rate)
	av.z = clamp(av.z, -max_roll_rate, max_roll_rate)
	angular_velocity = av

func _update_wheel_mesh_rotation(delta):
	for wheel in [wheel_fl, wheel_fr, wheel_rl, wheel_rr]:
		if not wheel:
			continue
		var child_mesh = wheel.get_node_or_null("MeshInstance3D")
		if not child_mesh:
			continue

		# wheel.get_rpm() provided by VehicleWheel3D, wheel visual rotates along local X
		var rpm = wheel.get_rpm()
		var roll_delta = rpm / 60.0 * TAU * delta
		wheel_roll_angle[wheel.name] = fmod(wheel_roll_angle[wheel.name] + roll_delta, TAU)

		child_mesh.rotation_degrees.x = rad_to_deg(wheel_roll_angle[wheel.name])

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Lower COM and stiffer suspension for stability on high-speed turns
	center_of_mass_mode = CENTER_OF_MASS_MODE_CUSTOM
	center_of_mass = center_of_mass_offset
	linear_damp = linear_dampening
	angular_damp = angular_dampening
	for wheel in [wheel_fl, wheel_fr, wheel_rl, wheel_rr]:
		if not wheel:
			continue
		_set_wheel_property(wheel, "suspension_stiffness", 25.0)
		_set_wheel_property(wheel, "suspension_rest_length", 0.45)
		_set_wheel_property(wheel, "suspension_travel", 0.45)
		_set_wheel_property(wheel, "suspension_max_travel", 0.45)
		_set_wheel_property(wheel, "friction_slip", 2.0)

	if debug_wheel_properties:
		for wheel in [wheel_fl, wheel_fr, wheel_rl, wheel_rr]:
			if not wheel:
				continue
			print("=== wheel:", wheel.name)
			for p in wheel.get_property_list():
				print("  ", p.name, p.type)

func _input(event):
	if event is InputEventMouseMotion:
		camera_rotation_y -= event.relative.x * mouse_sensitivity
		camera_rotation_x -= event.relative.y * mouse_sensitivity

		camera_rotation_x = clamp(camera_rotation_x, -1.2, -0.1)

		spring_arm.rotation.y = camera_rotation_y
		spring_arm.rotation.x = camera_rotation_x

func _set_wheel_property(wheel, property_name, value):
	for p in wheel.get_property_list():
		if p.name == property_name:
			wheel.set(property_name, value)
			return

@export var mouse_sensitivity: float = 0.003
@export var debug_wheel_properties: bool = true
