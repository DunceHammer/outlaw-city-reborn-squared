extends CharacterBody3D


const PLAYER_PATH = "../../PlayerCharacter"
const ENEMY_DAMAGE = 25
const MODEL_NAME = "SK_BaseHuman_Anims"
const ANIM_ATTACK = "Zombie_Attack_1"
const ANIM_WALK = "Zombie_Walk"


var enemy_speed = 2.5
var player = null
var animation_player = null
var enemy_speed = 1
var player
var animation


func animate():
	if (is_attacking):
		animation_player.play(ANIM_ATTACK)
	else:
		animation_player.play(ANIM_WALK)


func attack_end():
	is_attacking = false


func hit_player():
	if (is_colliding_with_player):
		player.get_node("HealthComponent").damage(ENEMY_DAMAGE)



func _ready():
	player = get_node(PLAYER_PATH)
	assert(player, "Player not found")
	animation_player = get_node(MODEL_NAME).get_node("AnimationPlayer")
	assert(animation_player, "AnimationPlayer not found")
	$HealthComponent.died.connect(_on_died,0)


func _physics_process(_delta):
	var enemy_direction = (player.position - self.position).normalized()
	velocity = enemy_direction * enemy_speed

	if (is_colliding_with_player):
		is_attacking = true

	look_at(player.position, Vector3(0, 1, 0))
	move_and_slide()
	animate()
  

func _on_died():
	player = get_node("/root").get_child(0).get_node("PlayerCharacter")
	player.get_node("PointsComponent").add_points(50)
	queue_free()


func _on_player_collision_body_entered(body):
	if (body.name == ("PlayerCharacter")):
		is_colliding_with_player = true


func _on_player_collision_body_exited(body):
	if (body.name == ("PlayerCharacter")):
		is_colliding_with_player = false
