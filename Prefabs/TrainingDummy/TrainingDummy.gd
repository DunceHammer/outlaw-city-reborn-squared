extends CharacterBody3D

const PLAYER_PATH = "../PlayerCharacter"
const ENEMY_SPEED = 3
const ENEMY_ATTACK_WAIT_TIME = 2
const ENEMY_DAMAGE = 25

var player
var animation
var is_colliding_with_player = false

func _ready():
	$HealthComponent.damaged.connect(_on_damaged,0)
	$HealthComponent.died.connect(_on_died,0)

func _physics_process(delta):
	player = get_node(PLAYER_PATH)
	var enemy_direction = (player.position - self.position).normalized()
	velocity = enemy_direction * ENEMY_SPEED
	move_and_slide()

func _on_damaged(_damage: int):
	print("Health: " + str($HealthComponent.health) + "/" + str($HealthComponent.max_health))


func _on_died():
	var player = get_node("/root").get_child(0).get_node("PlayerCharacter")
	player.get_node("PointsComponent").add_points(50)
	queue_free()


func _on_player_collision_body_entered(body):
	if (body.name == ("PlayerCharacter")):
		print("collide")
		is_colliding_with_player = true
		$EnemyAttackCooldown.start(ENEMY_ATTACK_WAIT_TIME)

func _on_player_collision_body_exited(body):
	if (body.name == ("PlayerCharacter")):
		print("player exited")
		is_colliding_with_player = false
		$EnemyAttackCooldown.stop()


func _on_enemy_attack_cooldown_timeout():
	if (is_colliding_with_player):
		player.get_node("HealthComponent").damage(ENEMY_DAMAGE)
