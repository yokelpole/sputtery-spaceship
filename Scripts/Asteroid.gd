extends RigidBody2D

signal asteroid_has_collided_with_player
signal asteroid_has_collided_with_enemy
signal asteroid_has_collided_with_bullet

var last_hit_by_bullet = false

func _on_AsteroidBody_body_entered(body):
	if "EnemyBody" in body.name:
		call_deferred("emit_signal", "asteroid_has_collided_with_enemy", body, last_hit_by_bullet)
		last_hit_by_bullet = false
	if "PlayerBody" in body.name:
		call_deferred("emit_signal", "asteroid_has_collided_with_player", body)
		last_hit_by_bullet = false
	if "BulletBody" in body.name:
		last_hit_by_bullet = true
		call_deferred("emit_signal", "asteroid_has_collided_with_bullet", body)
