extends Node3D

@export var vehicle_scene: PackedScene
@export var road_height: float = 0.2

var vehicle: VehicleBody3D


func _ready() -> void:
	_spawn_vehicle()


func _spawn_vehicle() -> void:
	if not vehicle_scene:
		push_error("Vehicle Scene not assigned!")
		return
	
	vehicle = vehicle_scene.instantiate() as VehicleBody3D
	add_child(vehicle)
	
	# Position: Start der Straße
	vehicle.global_position = Vector3(0, road_height + 1.0, -180) # Y = Straßentiefe + Auto Höhe
	vehicle.global_rotation = Vector3.ZERO
	
	# Kamera optional direkt als Kind
	var cam = Camera3D.new()
	vehicle.add_child(cam)
	cam.transform.origin = Vector3(0, 5, 12) # hinter dem Auto
	cam.look_at(vehicle.global_position + Vector3(0, 1, 0), Vector3.UP)
