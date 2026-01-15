extends VehicleBody3D

@export var engine_power := 1800.0
@export var brake_power := 120.0
@export var max_steer := 0.6
@export var drift_slip := 2.5
@export var normal_slip := 1.2

@onready var rear_left := $RL
@onready var rear_right := $RR

func _physics_process(delta):
	# Gas
	if Input.is_action_pressed("gas_vor"):
		engine_force = engine_power
	elif Input.is_action_pressed("gas_zurueck"):
		engine_force = -engine_power / 2
	else:
		engine_force = 0

	# Lenken
	var steer := 0.0
	if Input.is_action_pressed("links"):
		steer = max_steer
	elif Input.is_action_pressed("rechts"):
		steer = -max_steer

	steering = steer

	# Handbremse + Drift
	if Input.is_action_pressed("handbremse"):
		brake = brake_power
		rear_left.wheel_friction_slip = drift_slip
		rear_right.wheel_friction_slip = drift_slip
	else:
		brake = 0
		rear_left.wheel_friction_slip = normal_slip
		rear_right.wheel_friction_slip = normal_slip
