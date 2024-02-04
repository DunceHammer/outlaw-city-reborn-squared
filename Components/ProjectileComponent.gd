extends Node
class_name ProjectileComponent


@export var speed = 25
@export var damage = 5
@export var lifetime = 5
var _target = Vector3(0,0,0)
var _parent = null
var _shooter = null


func set_target(target):
	_target = target


func rotation_to_target(target: Vector3) -> Vector3:
	var new_rotation = _parent.global_transform.basis.get_euler()
	new_rotation.y = atan2(target.x - _parent.global_transform.origin.x, target.z - _parent.global_transform.origin.z)
	return new_rotation


func fire(shooter: Node3D = null):
	var new_rotation = rotation_to_target(_target)
	_parent.global_transform.basis = Basis().rotated(Vector3(0, 1, 0), new_rotation.y)
	_shooter = shooter


func _ready():
	_parent = get_parent()
	_parent.connect("body_entered", on_body_entered, 0)
	

func _process(delta):
	lifetime -= delta
	_parent.global_transform.origin += _parent.global_transform.basis.z * speed * delta

	if (lifetime <= 0):
		_parent.queue_free()


func on_body_entered(body):
	if (body.has_node("HealthComponent") and body != _shooter):
		body.get_node("HealthComponent").damage(damage)
		_parent.queue_free()
