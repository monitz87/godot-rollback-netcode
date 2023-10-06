extends SGFixedNode2D

@onready var timer = $NetworkTimer
@onready var sprite = $Sprite2D
@onready var area = $SGArea2D

var type: int
var angle: float

func _network_spawn(data: Dictionary) -> void:
	set_global_fixed_position(SGFixed.from_float_vector2(data['position']))
	# angle = data['fixed_rotation']
	angle = data['rotation']
	type = data['type']
	area.sync_to_physics_engine()
	if type == 0:
		sprite.texture = load('res://assets/godot.png')
	elif type == 1:
		sprite.texture = load('res://icon.png')
	timer.start()
	timer.connect('timeout', _on_network_timer_timeout)


func _network_process(_input: Dictionary) -> void:
	fixed_position = SGFixed.from_float_vector2(position + Vector2.from_angle(angle) * 4)
	area.sync_to_physics_engine()
	# fixed_position = fixed_position.add(SGFixed.from_float_vector2(Vector2.from_angle(angle2) * 4))
	# fixed_position = fixed_position.add(SGFixed.vector2(SGFixed.cos(angle), SGFixed.sin(angle)).mul(4 * SGFixed.ONE))	

func _network_postprocess(_input: Dictionary):
	if area.get_overlapping_area_count() > 0:
		SyncManager.despawn(self)


func _save_state() -> Dictionary:
	return {
		position = position,
		# position_x = fixed_position.x,
		# position_y = fixed_position.y,
	}


func _load_state(state: Dictionary) -> void:
	fixed_position = SGFixed.from_float_vector2(state.position)
	area.sync_to_physics_engine()


func _on_network_timer_timeout():
	SyncManager.despawn(self)
