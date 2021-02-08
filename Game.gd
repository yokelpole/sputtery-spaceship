extends Node2D

signal bullet_has_collided_with_enemy
signal enemy_has_collided_with_player

var SHIP_SHOOT_DELAY_ACTIVE = false
var DELAY_BETWEEN_SHOTS = 0.5
var SCREEN_WIDTH = ProjectSettings.get_setting("display/window/size/width")
var SCREEN_HEIGHT = ProjectSettings.get_setting("display/window/size/height")

func _ready():
	randomize()
	$EnemyTimer.start()
	
func _process(delta):
	if $ShipBody.visible == false:
		return
	
	if Input.is_action_pressed("ui_accept") and SHIP_SHOOT_DELAY_ACTIVE == false:
		SHIP_SHOOT_DELAY_ACTIVE = true
		
		var new_bullet = $BulletBody.duplicate()
		add_child(new_bullet)
		var ship_extents = $ShipBody/ShipCollisionShape.shape.extents
		var x_position = ($ShipBody.position.x + ship_extents.x * 2) - $ShipBody.rotation_degrees
		var y_position = ($ShipBody.position.y + ship_extents.y) + $ShipBody.rotation_degrees * 4
		new_bullet.position = Vector2(x_position, y_position)
		new_bullet.rotation_degrees = $ShipBody.rotation_degrees
		new_bullet.linear_velocity = Vector2(500, $ShipBody.rotation_degrees * 16)
		new_bullet.gravity_scale = 0
		new_bullet.visible = true

		yield(get_tree().create_timer(DELAY_BETWEEN_SHOTS), "timeout")

		SHIP_SHOOT_DELAY_ACTIVE = false

func _on_bullet_has_collided_with_enemy(area):
	self.remove_child(area.get_parent())

func _on_enemy_has_collided_with_player(area):

	$ShipBody._on_enemy_has_collided_with_player(area)

func _on_EnemyTimer_timeout():
	var new_enemy = $EnemyBody.duplicate() 
	add_child(new_enemy)
	new_enemy.connect("bullet_has_collided_with_enemy", self, "_on_bullet_has_collided_with_enemy")
	new_enemy.connect("enemy_has_collided_with_player", self, "_on_enemy_has_collided_with_player")
	new_enemy.global_position = Vector2(SCREEN_WIDTH, rand_range(10, 500))
	new_enemy.linear_velocity = Vector2(-500, 0)

func _on_BackgroundTimer_timeout():
	# TODO: Make this bounce back after one full cycle
	var current_pos = $ParallaxBackground/ParallaxLayer/TextureRect.rect_position
	$ParallaxBackground/ParallaxLayer/TextureRect.set_position(Vector2(current_pos.x - 1, current_pos.y))
