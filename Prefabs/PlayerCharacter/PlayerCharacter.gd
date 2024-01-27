extends CharacterBody3D


const MOVEMENT_SPEED = 500.0
const JUMP_VELOCITY = 4.5
const GRAVITY = 20.0
const RAYCAST_LENGTH = 1000.0


# TODO - not hardcode movement keys
func is_pressing_x_axis_keys() -> bool:
	return Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_D)


func is_pressing_z_axis_keys() -> bool:
	return Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_S)


func handle_movement_input(delta):
	var adjusted_speed = MOVEMENT_SPEED * delta

	velocity.x = 0.0
	velocity.z = 0.0
	if is_pressing_x_axis_keys():
		velocity.x = adjusted_speed if Input.is_key_pressed(KEY_A) else -adjusted_speed
	
	if is_pressing_z_axis_keys():
		velocity.z = adjusted_speed if Input.is_key_pressed(KEY_W) else -adjusted_speed

	move_and_slide()


# this wasn't fun.
# basically, get mouse position, raycast to world, get hit position, and rotate.
func handle_mouse_input():
	var space_state = get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	var raycast_source = $Camera3D.project_ray_origin(mouse_pos)
	var raycast_dest = raycast_source + $Camera3D.project_ray_normal(mouse_pos) * RAYCAST_LENGTH
	var query = PhysicsRayQueryParameters3D.create(raycast_source, raycast_dest)
	var result = space_state.intersect_ray(query)
	
	if result:
		var hit_pos = result.position
		var new_rotation = $Swivel.global_transform.basis.get_euler()
		new_rotation.y = atan2(hit_pos.x - $Swivel.global_transform.origin.x, hit_pos.z - $Swivel.global_transform.origin.z)
		$Swivel.global_transform.basis = Basis().rotated(Vector3(0, 1, 0), new_rotation.y)


func initialize():
	$HealthComponent.connect("died", on_died, 0)
	$HealthComponent.connect("damaged", on_damaged, 0)


func on_died():
	print("Player died")


func on_damaged(damage_amount: int):
	print("Player took " + str(damage_amount) + " damage")
	print("Player health: " + str($HealthComponent.health))


func _ready():
	initialize()	


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	handle_movement_input(delta)
	handle_mouse_input()
	move_and_slide()

