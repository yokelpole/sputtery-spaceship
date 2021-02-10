extends RigidBody2D

var SHIP_BUMP_POWER_Y = -500
var SHIP_BUMP_TORQUE_POWER = -10000
var DELAY_BETWEEN_BUMPS = 0.50
var SHIP_BUMP_DELAY_ACTIVE = false

var score = 0

onready var ship_collision_shape = $ShipCollisionShape
onready var ship_sprite = $ShipSprite

func _integrate_forces(state):
	if Input.is_action_pressed("ui_up") and SHIP_BUMP_DELAY_ACTIVE == false:
		SHIP_BUMP_DELAY_ACTIVE = true
		apply_impulse(Vector2(0, 0), Vector2(0, SHIP_BUMP_POWER_Y))
		apply_torque_impulse(SHIP_BUMP_TORQUE_POWER)
		yield(get_tree().create_timer(DELAY_BETWEEN_BUMPS), "timeout")
		SHIP_BUMP_DELAY_ACTIVE = false

func _on_enemy_has_collided_with_player(area):
	$ExplosionSprite.visible = true
	$ExplosionSprite.play("boom")
	$ExplosionSprite.playing = true
	$ShipSprite.visible = false

func _on_ExplosionSprite_animation_finished():
	queue_free()
