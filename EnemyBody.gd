extends RigidBody2D

var has_been_hit = false

signal bullet_has_collided_with_enemy
signal enemy_has_collided_with_player

func on_enemy_collision():
	if $EnemySprite == null:
		return
	
	if has_been_hit == false:
		gravity_scale = 5.0
		linear_velocity.x = -250
		has_been_hit = true
	else:
		$ExplosionSprite.visible = true
		$ExplosionSprite.play("boom")
		$ExplosionSprite.playing = true
		$EnemySprite.visible = false

func _on_EnemyBodyArea_area_entered(area):
	if area.name == "ShipBodyArea":
		emit_signal("enemy_has_collided_with_player", area)
	if area.name == "BulletBodyArea":
		emit_signal("bullet_has_collided_with_enemy", area)
		on_enemy_collision()
	if area.name == "AsteroidBodyArea":
		on_enemy_collision()
	if area.name == "EnemyBodyArea":
		on_enemy_collision()

func _on_ExplosionSprite_animation_finished():
	queue_free()
