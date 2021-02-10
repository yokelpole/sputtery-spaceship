extends Node2D

var SHIP_SHOOT_DELAY_ACTIVE = false
var DELAY_BETWEEN_SHOTS = 0.5
var SCREEN_WIDTH = ProjectSettings.get_setting("display/window/size/width")
var SCREEN_HEIGHT = ProjectSettings.get_setting("display/window/size/height")

var Player = preload("res://Player.tscn")
var Enemy = preload("res://Enemy.tscn")
var Asteroid = preload("res://Asteroid.tscn")
var Bullet = preload("res://Bullet.tscn")

var background_updates = 0
var player = null

func _ready():
	randomize()
	$EnemyTimer.start()
	$AsteroidTimer.start()
	player = Player.instance()
	add_child(player)
	
func _process(_delta):
	if player.visible == false:
		return
	
	if Input.is_action_pressed("ui_accept") and SHIP_SHOOT_DELAY_ACTIVE == false:
		SHIP_SHOOT_DELAY_ACTIVE = true
		
		var new_bullet = Bullet.instance()
		add_child(new_bullet)
		var ship_extents = player.ship_collision_shape.shape.extents
		var x_position = (player.position.x + ship_extents.x * 2) - player.rotation_degrees
		var y_position = (player.position.y + ship_extents.y) + player.rotation_degrees * 4
		new_bullet.position = Vector2(x_position, y_position)
		new_bullet.rotation_degrees = player.rotation_degrees
		new_bullet.linear_velocity = Vector2(500, player.rotation_degrees * 16)
		new_bullet.gravity_scale = 0
		new_bullet.visible = true

		yield(get_tree().create_timer(DELAY_BETWEEN_SHOTS), "timeout")

		SHIP_SHOOT_DELAY_ACTIVE = false

func _on_bullet_has_collided_with_enemy(area):
	remove_child(area.get_parent())

func _on_asteroid_has_collided_with_enemy(area):
	area.get_parent().on_enemy_collision()

func _on_enemy_has_collided_with_player(area):
	player._on_enemy_has_collided_with_player(area)

func _on_asteroid_has_collided_with_player(area):
	player._on_enemy_has_collided_with_player(area)

func _on_EnemyTimer_timeout():
	var new_enemy = Enemy.instance()
	self.add_child(new_enemy)
	new_enemy.connect("bullet_has_collided_with_enemy", self, "_on_bullet_has_collided_with_enemy")
	new_enemy.connect("enemy_has_collided_with_player", self, "_on_enemy_has_collided_with_player")
	new_enemy.global_position = Vector2(SCREEN_WIDTH, rand_range(10, 500))
	new_enemy.linear_velocity = Vector2(-500, 0)

func _on_AsteroidTimer_timeout():
	var new_asteroid = Asteroid.instance()
	add_child(new_asteroid)
	new_asteroid.global_position = Vector2(SCREEN_WIDTH, rand_range(10, 500))
	new_asteroid.linear_velocity = Vector2(-200, 0)
	new_asteroid.connect("asteroid_has_collided_with_player", self, "_on_asteroid_has_collided_with_player")
	new_asteroid.connect("asteroid_has_collided_with_enemy", self, "_on_asteroid_has_collided_with_enemy")
	new_asteroid.angular_velocity = 2.5

func _on_BackgroundTimer_timeout():
	var current_pos = $ParallaxBackground/ParallaxLayer/TextureRect.rect_position
	if background_updates == 402:
		background_updates = 0
		$ParallaxBackground/ParallaxLayer/TextureRect.set_position(Vector2(current_pos.x + 402, current_pos.y))
	else:
		background_updates = background_updates + 1
		$ParallaxBackground/ParallaxLayer/TextureRect.set_position(Vector2(current_pos.x - 1, current_pos.y))
