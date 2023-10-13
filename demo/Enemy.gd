extends StaticBody2D

const Bullet = preload("res://demo/Bullet.tscn")

@onready var timer = $NetworkTimer
var fixed_rotation: int

func _network_process(_input: Dictionary) -> void:
	rotation = snapped(fmod(rotation + 0.1, 2 * PI), 0.01)


func _save_state() -> Dictionary:
	return {
		rotation = rotation,
	}


func _load_state(state: Dictionary) -> void:
	rotation = state['rotation']


func _on_network_timer_timeout():
	SyncManager.spawn("Bullet", get_parent(), Bullet, {
		position = position,
		rotation = rotation,
		type = 0 
	})
	SyncManager.spawn("Bullet", get_parent(), Bullet, {
		position = position,
		rotation = snapped(fmod(rotation + PI, 2 * PI), 0.01),
		type = 0 
	})
	SyncManager.spawn("Bullet", get_parent(), Bullet, {
		position = position,		
		rotation = snapped(fmod(rotation + PI/2, 2 * PI/2), 0.01),
		type = 1
	})
	SyncManager.spawn("Bullet", get_parent(), Bullet, {
		position = position,		
		rotation = snapped(fmod(rotation + 3*PI/2, 2 * PI), 0.01),
		type = 1
	})
	