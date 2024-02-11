extends CharacterBody3D


const MOVEMENT_SPEED = 500.0
const GRAVITY = 20.0
const RAYCAST_LENGTH = 1000.0


var is_moving = false
var is_firing = false
var fire_time = 0.0
var legs_target = 0.0
var legs_rotate_speed = 0.1
var selected_interactable = null


func start_fire_timer(time: float):
	is_firing = true
	fire_time = time


func _ready():
	$HealthComponent.died.connect(_on_died,0)


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

	is_moving = velocity.x or velocity.z
	move_and_slide()


func handle_interaction_input():
	if Input.is_key_pressed(KEY_E) and selected_interactable:
		if selected_interactable.get_node("InteractableComponent").try_interact(self):
			selected_interactable = null


func get_object_under_mouse() -> Dictionary:
	var space_state = get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	var raycast_source = $Camera3D.project_ray_origin(mouse_pos)
	var raycast_dest = raycast_source + $Camera3D.project_ray_normal(mouse_pos) * RAYCAST_LENGTH
	var query = PhysicsRayQueryParameters3D.create(raycast_source, raycast_dest)
	return space_state.intersect_ray(query)


func rotate_swivel_to_position(pos: Vector3):
	var new_rotation = $Swivel.global_transform.basis.get_euler()
	new_rotation.y = atan2(pos.x - $Swivel.global_transform.origin.x, pos.z - $Swivel.global_transform.origin.z)
	$Swivel.global_transform.basis = Basis().rotated(Vector3(0, 1, 0), new_rotation.y)


func handle_mouse_input():
	var hit = get_object_under_mouse()
	if hit:
		var hit_object = hit.collider

		if hit_object.has_node("InteractableComponent"):
			selected_interactable = hit_object
		else:
			selected_interactable = null

		rotate_swivel_to_position(hit.position)
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			$WeaponComponent.attack(hit.position)
		


func determine_legs_target():
	if not is_moving:
		legs_target = rad_to_deg($Swivel.rotation.y)
		legs_rotate_speed = 0.15
	else:
		var target_y = 0.0
		
		# this should be changed to use radians from the beginning
		# currently, this is calculated in degrees, then converted to radians later.
		# I'm sure this can also be made more concise by someone who knows math better than I do.
		if velocity.x != 0:
			target_y = 90 if velocity.x > 0 else 280
			if velocity.z > 0:
				target_y = 45 if velocity.x > 0 else 315
			elif velocity.z < 0:
				target_y = 135 if velocity.x > 0 else 225
		elif velocity.z != 0:
			target_y = 0 if velocity.z > 0 else 180

		legs_target = target_y
		legs_rotate_speed = 0.1


func rotate_legs(delta):
	$Legs.rotation.y = lerp_angle($Legs.rotation.y, deg_to_rad(legs_target), legs_rotate_speed * (delta * 50))


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	if is_firing:
		fire_time -= delta
		if fire_time <= 0:
			is_firing = false
	
	handle_movement_input(delta)
	handle_mouse_input()
	handle_interaction_input()
	determine_legs_target()
	rotate_legs(delta)
	move_and_slide()


func _on_died():
	get_tree().change_scene_to_file("res://Scenes/death_menu.tscn")
