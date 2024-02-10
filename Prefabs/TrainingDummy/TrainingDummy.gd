extends CharacterBody3D


const PLAYER_PATH = "../../PlayerCharacter"
const ENEMY_ATTACK_WAIT_TIME = 2
const ENEMY_DAMAGE = 25


var enemy_speed = 1
var player
var animation
var is_colliding_with_player = false


func _ready():
	$HealthComponent.died.connect(_on_died,0)


func _physics_process(delta):
	player = get_node(PLAYER_PATH)
	var enemy_direction = (player.position - self.position).normalized()
	velocity = enemy_direction * enemy_speed
	move_and_slide()


func _on_died():
	var player = get_node("/root").get_child(0).get_node("PlayerCharacter")
	player.get_node("PointsComponent").add_points(50)
	queue_free()


func _on_player_collision_body_entered(body):
	if (body.name == ("PlayerCharacter")):
		is_colliding_with_player = true
		$EnemyAttackCooldown.start(ENEMY_ATTACK_WAIT_TIME)

func _on_player_collision_body_exited(body):
	if (body.name == ("PlayerCharacter")):
		is_colliding_with_player = false
		$EnemyAttackCooldown.stop()


func _on_enemy_attack_cooldown_timeout():
	if (is_colliding_with_player):
		player.get_node("HealthComponent").damage(ENEMY_DAMAGE)
