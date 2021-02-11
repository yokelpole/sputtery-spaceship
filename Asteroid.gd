extends RigidBody2D

signal asteroid_has_collided_with_player
signal asteroid_has_collided_with_enemy
signal asteroid_has_collided_with_bullet

func _on_AsteroidBodyArea_area_entered(area):
	if area.name == "EnemyBodyArea":
		emit_signal("asteroid_has_collided_with_enemy", area)
	if area.name == "PlayerBodyArea":
		emit_signal("asteroid_has_collided_with_player", area)
	if area.name == "BulletBodyArea":
		emit_signal("asteroid_has_collided_with_bullet", area)
