extends RigidBody2D

var SHIP_BUMP_POWER_Y = -400
var DELAY_BETWEEN_BUMPS = 0.25
var DELAY_BETWEEN_SHOTS = 0.5
var SHIP_BUMP_DELAY_ACTIVE = false
var SHIP_SHOOT_DELAY_ACTIVE = false
var SHIP_DISABLED_ACTIVE = false
var score = 0

signal player_shoot_bullet

onready var collision_shape = $PlayerCollisionShape
onready var sprite = $PlayerSprite

func _integrate_forces(_state):
	if position.y <= -20 and SHIP_DISABLED_ACTIVE == false:
		SHIP_DISABLED_ACTIVE = true
		apply_impulse(Vector2(0, 0), Vector2(0, 5))
		$BlinkingTimer.start()
		$DisabledTimer.start()
		return
	
	if SHIP_BUMP_DELAY_ACTIVE or SHIP_DISABLED_ACTIVE:
		return
	
	if Input.is_action_pressed("ui_accept"):
		shoot()
	
	if Input.is_action_pressed("ui_up"):
		bump()

func shoot():
	if SHIP_SHOOT_DELAY_ACTIVE == true or SHIP_DISABLED_ACTIVE == true or $ExplosionSprite.visible == true:
		return
		
	SHIP_SHOOT_DELAY_ACTIVE = true
	call_deferred("emit_signal", "player_shoot_bullet")
	$LaserSound.play()
	yield(get_tree().create_timer(DELAY_BETWEEN_SHOTS), "timeout")
	SHIP_SHOOT_DELAY_ACTIVE = false

func bump():
	if SHIP_BUMP_DELAY_ACTIVE == true or SHIP_DISABLED_ACTIVE == true or $ExplosionSprite.visible == true:
		return
	
	SHIP_BUMP_DELAY_ACTIVE = true
	apply_impulse(Vector2(0, 0), Vector2(0, SHIP_BUMP_POWER_Y))
	$PlayerSprite/PlayerRocket.visible = true
	$RocketTimer.start()
	yield(get_tree().create_timer(DELAY_BETWEEN_BUMPS), "timeout")
	SHIP_BUMP_DELAY_ACTIVE = false

# FIXME: Currently accepts player body
func _on_object_has_collided_with_player(body):
	$ExplosionSprite.visible = true
	$ExplosionSprite.play("boom")
	$ExplosionSprite.playing = true
	$PlayerSprite.visible = false
	$ExplodeSound.play()

func _on_ExplosionSprite_animation_finished():
	queue_free()

func _on_DisabledTimer_timeout():
	SHIP_DISABLED_ACTIVE = false
	$BlinkingTimer.stop()
	$PlayerOverlaySprite.visible = false

func _on_BlinkingTimer_timeout():
	$PlayerOverlaySprite.visible = !$PlayerOverlaySprite.visible

func _on_RocketTimer_timeout():
	$PlayerSprite/PlayerRocket.visible = false
