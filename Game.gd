extends Node2D

var SCREEN_WIDTH = ProjectSettings.get_setting("display/window/size/width")
var SCREEN_HEIGHT = ProjectSettings.get_setting("display/window/size/height")

var Player = preload("res://Player.tscn")
var Enemy = preload("res://Enemy.tscn")
var Asteroid = preload("res://Asteroid.tscn")
var Bullet = preload("res://Bullet.tscn")

var background_updates = 0
var end_score = 0
var player = null

func _ready():
	randomize()
	
func _process(_delta):
	if is_instance_valid(player) != true:
		if Input.is_action_pressed("ui_accept"):
			start_game()
		return
	
	$HudNode/Score.bbcode_text = "[right]SCORE: " + str(player.score) + "[/right]"

func start_game():
	if is_instance_valid(player) == true:
		return
	
	player = Player.instance()
	$TitleTextNode.visible = false
	$GameOverTextNode.visible = false
	
	yield(get_tree().create_timer(1), "timeout")
	
	add_child(player)
	player.connect("player_shoot_bullet", self, "_on_player_shoot_bullet")

	$HudNode.visible = true
	$HudNode/Score.bbcode_text = "[right]SCORE: 0[/right]"
	
	$EnemyTimer.start()
	$AsteroidTimer.start()
	$ScoreTimer.start()

func on_player_dead():
	end_score = player.score
	$EnemyTimer.stop()
	$AsteroidTimer.stop()
	$ScoreTimer.stop()
	$GameOverTextNode/GameOverText.text = "GAME OVER\nSCORE: " + str(end_score) + "\n\nTRY AGAIN?" 
	$HudNode/Score.bbcode_text = "[right]SCORE: 0[/right]"
	$GameOverTextNode.visible = true
	$HudNode.visible = false

func _on_bullet_has_collided_with_enemy(area):
	if is_instance_valid(player) != true:
		return
	
	player.score = player.score + 10
	remove_child(area.get_parent())

func _on_asteroid_has_collided_with_enemy(area):
	area.get_parent().on_enemy_collision()

func _on_asteroid_has_collided_with_bullet(area):
	area.get_parent().queue_free()

func _on_enemy_has_collided_with_player(area):
	player._on_enemy_has_collided_with_player(area)
	on_player_dead()

func _on_asteroid_has_collided_with_player(area):
	player._on_enemy_has_collided_with_player(area)
	on_player_dead()
	
func _on_player_shoot_bullet():
	var new_bullet = Bullet.instance()
	add_child(new_bullet)
	var ship_extents = player.collision_shape.shape.extents
	var x_position = (player.position.x + ship_extents.x * 2) - player.rotation_degrees
	var y_position = (player.position.y + ship_extents.y) + player.rotation_degrees * 4
	new_bullet.position = Vector2(x_position, y_position)
	new_bullet.rotation_degrees = player.rotation_degrees
	new_bullet.linear_velocity = Vector2(500, player.rotation_degrees * 16)
	new_bullet.gravity_scale = 0

func _on_EnemyTimer_timeout():
	var new_enemy = Enemy.instance()
	add_child(new_enemy)
	new_enemy.connect("bullet_has_collided_with_enemy", self, "_on_bullet_has_collided_with_enemy")
	new_enemy.connect("enemy_has_collided_with_player", self, "_on_enemy_has_collided_with_player")
	new_enemy.global_position = Vector2(SCREEN_WIDTH, rand_range(10, 500))
	new_enemy.linear_velocity = Vector2(-500, 0)

func _on_AsteroidTimer_timeout():
	var new_asteroid = Asteroid.instance()
	add_child(new_asteroid)
	new_asteroid.connect("asteroid_has_collided_with_player", self, "_on_asteroid_has_collided_with_player")
	new_asteroid.connect("asteroid_has_collided_with_enemy", self, "_on_asteroid_has_collided_with_enemy")
	new_asteroid.connect("asteroid_has_collided_with_bullet", self, "_on_asteroid_has_collided_with_bullet")
	new_asteroid.global_position = Vector2(SCREEN_WIDTH, rand_range(10, 500))
	new_asteroid.linear_velocity = Vector2(-200, 0)

func _on_BackgroundTimer_timeout():
	var current_pos = $ParallaxBackground/ParallaxLayer/TextureRect.rect_position
	if background_updates == 402:
		background_updates = 0
		$ParallaxBackground/ParallaxLayer/TextureRect.set_position(Vector2(current_pos.x + 402, current_pos.y))
	else:
		background_updates = background_updates + 1
		$ParallaxBackground/ParallaxLayer/TextureRect.set_position(Vector2(current_pos.x - 1, current_pos.y))

func _on_TitleText_gui_input(event):
	if event is InputEventMouseButton:
		start_game()

func _on_ScoreTimer_timeout():
	player.score = player.score + 1

func _on_PlanetArea2D_area_entered(area):
	if area.name == "EnemyBodyArea":
		area.get_parent().has_been_hit = true
		area.get_parent().on_enemy_collision()
	if area.name == "PlayerBodyArea":	
		player._on_enemy_has_collided_with_player(area)
		on_player_dead()

func _on_LeftTouchscreenButton_pressed():
	if is_instance_valid(player) != true:
		return
	
	player.bump()

func _on_RightTouchscreenButton_pressed():
	if is_instance_valid(player) != true:
		return
		
	player.shoot()
