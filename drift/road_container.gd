extends Node3D

@export var segment_scene: PackedScene
@export var count: int = 10
@export var segment_length: float = 40.0

func _ready():
	var pos = Vector3.ZERO
	for i in count:
		var seg = segment_scene.instantiate()
		add_child(seg)
		seg.position = pos
		pos.z += segment_length

# vehicle.gd
func _process(delta):
	var target = Vector3(0, 5, 12)
	$SpringArm3D.transform.origin = $SpringArm3D.transform.origin.lerp(target, 5 * delta)
