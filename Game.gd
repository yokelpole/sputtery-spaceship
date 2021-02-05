extends Node2D

var SHIP_SHOOT_DELAY_ACTIVE = false
var DELAY_BETWEEN_SHOTS = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	print("### STARTING ENEMY TIMER")
	$EnemyTimer.start()
	
func _process(delta):
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

func _on_EnemyTimer_timeout():
	var new_enemy = $EnemyBody.duplicate()
	add_child(new_enemy)
	new_enemy.position.y = 70
	new_enemy.linear_velocity = Vector2(-500, 0)

func _on_EnemyBodyArea_area_entered(area):
	if area.name == "ShipBodyArea":
		$ShipBody.visible = false
