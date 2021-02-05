extends RigidBody2D

var SHIP_BUMP_POWER_Y = -125
var SHIP_BUMP_TORQUE_POWER = -3300
var DELAY_BETWEEN_BUMPS = 0.50
var SHIP_BUMP_DELAY_ACTIVE = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _integrate_forces(state):
	if Input.is_action_pressed("ui_up") and SHIP_BUMP_DELAY_ACTIVE == false:
		SHIP_BUMP_DELAY_ACTIVE = true
		apply_impulse(Vector2(0, 0), Vector2(0, SHIP_BUMP_POWER_Y))
		apply_torque_impulse(SHIP_BUMP_TORQUE_POWER)
		yield(get_tree().create_timer(DELAY_BETWEEN_BUMPS), "timeout")
		SHIP_BUMP_DELAY_ACTIVE = false
	
