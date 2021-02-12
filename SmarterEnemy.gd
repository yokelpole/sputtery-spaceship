extends RigidBody2D

var has_been_hit = false
var speed = 500
var path: PoolVector2Array = PoolVector2Array()

signal bullet_has_collided_with_enemy
signal enemy_has_collided_with_player

onready var sprite: Sprite = $EnemySprite

func _process(delta):
	var distance_to_walk = speed * delta
	
	print(path)
	
	if distance_to_walk > 0 and path.size() > 0 and has_been_hit == false:
		var distance_to_next_point = position.distance_to(path[0])
		
		if distance_to_walk <= distance_to_next_point:
			# Not have enough movement left to get to the next point.
			position += position.direction_to(path[0]) * distance_to_walk
		else:
			linear_velocity = Vector2(-speed, 0)
			path = []
			
		distance_to_walk -= distance_to_next_point

func on_enemy_collision():
	if $EnemySprite == null:
		return
	
	if has_been_hit == false:
		$EnemySprite/SmokeSprite.visible = true
		gravity_scale = 5.0
		linear_velocity.x = -250
		has_been_hit = true
	else:
		$ExplosionSprite.visible = true
		$ExplosionSprite.play("boom")
		$ExplosionSprite.playing = true
		$EnemySprite.visible = false

func _on_EnemyBodyArea_area_entered(area):
	if area.name == "PlayerBodyArea":
		call_deferred("emit_signal", "enemy_has_collided_with_player", area)
	if area.name == "BulletBodyArea":
		call_deferred("emit_signal", "bullet_has_collided_with_enemy", area)
		on_enemy_collision()
	if area.name == "AsteroidBodyArea":
		on_enemy_collision()
	if area.name == "EnemyBodyArea":
		on_enemy_collision()

func _on_ExplosionSprite_animation_finished():
	queue_free()
