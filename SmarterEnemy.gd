extends "BaseEnemy.gd"

var speed = 5
var path: PoolVector2Array = PoolVector2Array()

func _integrate_forces(state):
	var distance_to_walk = speed
	
	if distance_to_walk > 0 and path.size() > 0 and has_been_hit == false:
		var distance_to_next_point = position.distance_to(path[0])
		
		if distance_to_walk <= distance_to_next_point:
			# Not have enough movement left to get to the next point.
			add_central_force(position.direction_to(path[0]) * distance_to_walk)
		else:
			linear_velocity = Vector2(-speed, 0)
			path = []
			
		distance_to_walk -= distance_to_next_point
