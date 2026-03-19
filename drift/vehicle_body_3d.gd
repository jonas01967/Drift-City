extends VehicleBody3D

@export var max_engine_force: float = 4000.0
@export var max_reverse_force: float = 2000.0
@export var max_steering_angle: float = 0.5
@export var brake_force: float = 800.0

func _physics_process(delta):
	engine_force = 0
	brake = 0
	steering = 0

	# Vorwärts fahren
	if Input.is_action_pressed("ui_up"):
		engine_force = max_engine_force

	# Rückwärts fahren
	if Input.is_action_pressed("ui_down"):
		engine_force = -max_reverse_force

	# Lenken
	if Input.is_action_pressed("ui_left"):
		steering = max_steering_angle
	if Input.is_action_pressed("ui_right"):
		steering = -max_steering_angle

@export var mouse_sensitivity: float = 0.003
@onready var spring_arm: SpringArm3D = $SpringArm3D

var camera_rotation_y: float = 0.0
var camera_rotation_x: float = -0.3

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		camera_rotation_y -= event.relative.x * mouse_sensitivity
		camera_rotation_x -= event.relative.y * mouse_sensitivity
		
		camera_rotation_x = clamp(camera_rotation_x, -1.2, -0.1)
		
		spring_arm.rotation.y = camera_rotation_y
		spring_arm.rotation.x = camera_rotation_x
