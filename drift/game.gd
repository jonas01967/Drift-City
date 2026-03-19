extends Node3D

@export var vehicle_scene: PackedScene
@export var road_height: float = 0.2

var vehicle: VehicleBody3D


func _ready() -> void:
	_spawn_vehicle()


func _spawn_vehicle() -> void:
	if vehicle_scene == null:
		push_error("Vehicle scene is NULL")
		return
	
	var instance = vehicle_scene.instantiate()
	
	if not instance is VehicleBody3D:
		push_error("Scene is not a VehicleBody3D")
		return
	
	vehicle = instance as VehicleBody3D   # ← KEIN var hier!
	add_child(vehicle)
	
	# Positioniere das Fahrzeug so, dass die Räder auf der Straße aufliegen.
	# road_height ist die Höhe des Straßen-Blocks (z.B. 0.2), daher ist die Oberfläche bei road_height/2.
	vehicle.global_position = Vector3(0, road_height / 2.0 + 1.0, 0)
