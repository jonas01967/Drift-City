extends Node3D

@export var wheel: VehicleWheel3D
@export var skid_scene: PackedScene
@export var slip_threshold := 2.0

func _physics_process(_delta):
	if wheel.get_skidinfo() > slip_threshold and wheel.is_in_contact():
		spawn_mark()

func spawn_mark():
	var skid = skid_scene.instantiate()
	skid.global_position = wheel.global_position
	skid.rotation.y = wheel.global_rotation.y
	get_parent().add_child(skid)
	
func _ready():
	await get_tree().create_timer(8).timeout
	queue_free()
