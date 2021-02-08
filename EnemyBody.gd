extends RigidBody2D

var has_been_hit = false

signal bullet_has_collided_with_enemy
signal enemy_has_collided_with_player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.\

func on_ship_collision():
	if has_been_hit == false:
		gravity_scale = 5.0
		linear_velocity.x = -250
		has_been_hit = true
	else:
		$ExplosionSprite.visible = true
		$ExplosionSprite.play("boom")
		$ExplosionSprite.playing = true
		$EnemySprite.visible = false
		# self.remove_and_skip()

func _on_EnemyBodyArea_area_entered(area):
	if area.name == "ShipBodyArea":
		emit_signal("enemy_has_collided_with_player", area)
	if area.name == "BulletBodyArea":
		emit_signal("bullet_has_collided_with_enemy", area)
		on_ship_collision()
	if area.name == "EnemyBodyArea":
		on_ship_collision()


func _on_ExplosionSprite_animation_finished():
	# remove_and_skip()
	pass
