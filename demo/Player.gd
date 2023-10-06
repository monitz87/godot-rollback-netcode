extends SGFixedNode2D

@export var input_prefix: String = "player1_"

@onready var area = $SGArea2D

enum PlayerInputKey {
	INPUT_VECTOR,
}

var score := 0
var multiplier := 1

func _ready():
	area.sync_to_physics_engine()

func _save_state() -> Dictionary:
	return {
		position = position,
		score = score,
		multiplier = multiplier,
	}


func _load_state(state: Dictionary) -> void:
	fixed_position = SGFixed.from_float_vector2(state['position'])
	score = state['score']
	multiplier = state['multiplier']
	area.sync_to_physics_engine()


func _interpolate_state(old_state: Dictionary, new_state: Dictionary, weight: float) -> void:
	fixed_position.x = lerp(SGFixed.from_float_vector2(old_state['position']).x, SGFixed.from_float_vector2(new_state['position']).x, weight)
	fixed_position.y = lerp(SGFixed.from_float_vector2(old_state['position']).y, SGFixed.from_float_vector2(new_state['position']).y, weight)


func _get_local_input() -> Dictionary:
	var input_vector = Vector2(
		int(Input.is_action_pressed(input_prefix + "right")) - int(Input.is_action_pressed(input_prefix + "left")),
		int(Input.is_action_pressed(input_prefix + "down")) - int(Input.is_action_pressed(input_prefix + "up"))
	)
	var input := {}
	if input_vector != Vector2.ZERO:
		input[PlayerInputKey.INPUT_VECTOR] = input_vector
	
	return input


func _predict_remote_input(previous_input: Dictionary, ticks_since_real_input: int) -> Dictionary:
	var input = previous_input.duplicate()
	if ticks_since_real_input > 5:
		input.erase(PlayerInputKey.INPUT_VECTOR)
	return input


func _network_process(input: Dictionary) -> void:
	fixed_position = SGFixed.from_float_vector2(position + input.get(PlayerInputKey.INPUT_VECTOR, Vector2.ZERO) * 16)
	area.sync_to_physics_engine()


func _network_postprocess(_input: Dictionary) -> void:
	var overlapping_areas = area.get_overlapping_areas()
	for overlapping_area in overlapping_areas:
		var bullet = overlapping_area.owner
		var type = bullet.get("type")
		if type == 0:
			score += 1 * multiplier
		elif type == 1:
			multiplier += 1
		else:
			print("Unknown bullet type: " + str(type))
