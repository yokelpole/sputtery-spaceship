extends RigidBody2D

signal asteroid_has_collided_with_player
signal asteroid_has_collided_with_enemy

func _on_AsteroidBodyArea_area_entered(area):
	if area.name == "EnemyBodyArea":
		emit_signal("asteroid_has_collided_with_enemy", area)
	if area.name == "ShipBodyArea":
		emit_signal("asteroid_has_collided_with_player", area)
	pass # Replace with function body.
