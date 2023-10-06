extends StaticBody2D

const Bullet = preload("res://demo/Bullet.tscn")

@onready var timer = $NetworkTimer
var fixed_rotation: int

func _network_process(_input: Dictionary) -> void:
	# fixed_rotation = (fixed_rotation + 6554) % (2 * SGFixed.PI)
	rotation = fmod(rotation + 0.1, 2 * PI)


func _save_state() -> Dictionary:
	return {
		# fixed_rotation = fixed_rotation,
		rotation = rotation,
	}


func _load_state(state: Dictionary) -> void:
	# fixed_rotation = state['fixed_rotation']
	rotation = state['rotation']


func _on_network_timer_timeout():
	SyncManager.spawn("Bullet", get_parent(), Bullet, {
		position = position,
		# fixed_rotation = fixed_rotation,
		rotation = rotation,
		type = 0 
	})
	SyncManager.spawn("Bullet", get_parent(), Bullet, {
		position = position,
		# fixed_rotation = (fixed_rotation + SGFixed.PI) % (2 * SGFixed.PI),
		rotation = fmod(rotation + PI, 2 * PI),
		type = 0 
	})
	SyncManager.spawn("Bullet", get_parent(), Bullet, {
		position = position,
		# fixed_rotation = (fixed_rotation + SGFixed.PI_DIV_2) % (2 * SGFixed.PI),
		rotation = fmod(rotation + PI/2, 2 * PI/2),
		type = 1
	})
	SyncManager.spawn("Bullet", get_parent(), Bullet, {
		position = position,
		# fixed_rotation = (fixed_rotation + 3 * SGFixed.PI_DIV_2) % (2 * SGFixed.PI),
		rotation = fmod(rotation + 3*PI/2, 2 * PI),
		type = 1
	})
	