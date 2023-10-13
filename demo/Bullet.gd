extends Node2D

@onready var timer = $NetworkTimer
@onready var sprite = $Sprite2D
@onready var area: Area2D = $Area2D

var type: int
var angle: float

func _network_spawn(data: Dictionary) -> void:
	global_position = data['position']
	angle = data['rotation']
	type = data['type']
	if type == 0:
		sprite.texture = load('res://assets/godot.png')
	elif type == 1:
		sprite.texture = load('res://icon.png')
	timer.start()
	timer.connect('timeout', _on_network_timer_timeout)


func _network_process(_input: Dictionary) -> void:
	position += snapped(Vector2.from_angle(angle) * 4, Vector2(0.01, 0.01))

func _network_postprocess(_input: Dictionary):
	if area.get_overlapping_areas().size() > 0:
		SyncManager.despawn(self)


func _save_state() -> Dictionary:
	return {
		position = position,
	}


func _load_state(state: Dictionary) -> void:
	position = state.position


func _on_network_timer_timeout():
	SyncManager.despawn(self)
