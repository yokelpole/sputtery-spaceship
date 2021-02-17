extends RigidBody2D

var has_been_hit = false

signal bullet_has_collided_with_enemy
signal enemy_has_collided_with_player

onready var sprite: Sprite = $EnemySprite

func _process(_delta):
	if position.x < 800:
		$EnemyCollisionShape.disabled = false

func on_enemy_collision(body):
	if position.x > 800 and ("EnemyBody" in body.name or "AsteroidBody" in body.name):
		return
	
	if has_been_hit == false and !("AsteroidBody" in body.name):
		$EnemySprite/SmokeSprite.visible = true
		gravity_scale = 5.0
		linear_velocity.x = -250
		has_been_hit = true
	else:
		$ExplosionSprite.visible = true
		$ExplosionSprite.play("boom")
		$ExplosionSprite.playing = true
		set_deferred("$EnemyCollisionShape.disabled", true)
		$EnemySprite.visible = false

func _on_EnemyBody_body_entered(body):
	if "PlayerBody" in body.name:
		call_deferred("emit_signal", "enemy_has_collided_with_player", body)
	if "BulletBody" in body.name:
		call_deferred("emit_signal", "bullet_has_collided_with_enemy", body)
		on_enemy_collision(body)
	if "AsteroidBody" in body.name:
		on_enemy_collision(body)
	if "EnemyBody" in body.name:
		on_enemy_collision(body)

func _on_ExplosionSprite_animation_finished():
	queue_free()
