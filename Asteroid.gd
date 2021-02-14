extends RigidBody2D

signal asteroid_has_collided_with_player
signal asteroid_has_collided_with_enemy
signal asteroid_has_collided_with_bullet

func _on_AsteroidBody_body_entered(body):
	if "EnemyBody" in body.name:
		call_deferred("emit_signal", "asteroid_has_collided_with_enemy", body)
	if "PlayerBody" in body.name:
		call_deferred("emit_signal", "asteroid_has_collided_with_player", body)
	if "BulletBody" in body.name:
		call_deferred("emit_signal", "asteroid_has_collided_with_bullet", body)
