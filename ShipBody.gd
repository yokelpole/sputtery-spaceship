extends RigidBody2D

var SHIP_BUMP_POWER_Y = -450
var SHIP_BUMP_TORQUE_POWER = -2800
var DELAY_BETWEEN_BUMPS = 0.25
var DELAY_BETWEEN_SHOTS = 0.5
var SHIP_BUMP_DELAY_ACTIVE = false
var SHIP_SHOOT_DELAY_ACTIVE = false
var SHIP_DISABLED_ACTIVE = false
var score = 0

signal player_shoot_bullet

onready var collision_shape = $PlayerCollisionShape
onready var sprite = $PlayerSprite

func _integrate_forces(state):
	if position.y <= 0 and SHIP_DISABLED_ACTIVE == false:
		SHIP_DISABLED_ACTIVE = true
		apply_impulse(Vector2(0, 0), Vector2(0, 5))
		$BlinkingTimer.start()
		$DisabledTimer.start()
		return
	
	if SHIP_BUMP_DELAY_ACTIVE or SHIP_DISABLED_ACTIVE:
		return
	
	if Input.is_action_pressed("ui_accept") and SHIP_SHOOT_DELAY_ACTIVE == false:
		SHIP_SHOOT_DELAY_ACTIVE = true
		emit_signal("player_shoot_bullet")
		yield(get_tree().create_timer(DELAY_BETWEEN_SHOTS), "timeout")
		SHIP_SHOOT_DELAY_ACTIVE = false
	
	if Input.is_action_pressed("ui_up"):
		SHIP_BUMP_DELAY_ACTIVE = true
		apply_impulse(Vector2(0, 0), Vector2(0, SHIP_BUMP_POWER_Y))
		apply_torque_impulse(SHIP_BUMP_TORQUE_POWER)
		yield(get_tree().create_timer(DELAY_BETWEEN_BUMPS), "timeout")
		SHIP_BUMP_DELAY_ACTIVE = false

func _on_enemy_has_collided_with_player(area):
	$ExplosionSprite.visible = true
	$ExplosionSprite.play("boom")
	$ExplosionSprite.playing = true
	$PlayerSprite.visible = false

func _on_ExplosionSprite_animation_finished():
	queue_free()

func _on_DisabledTimer_timeout():
	SHIP_DISABLED_ACTIVE = false
	$BlinkingTimer.stop()
	$PlayerOverlaySprite.visible = false

func _on_BlinkingTimer_timeout():
	$PlayerOverlaySprite.visible = !$PlayerOverlaySprite.visible
