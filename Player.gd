extends Sprite

enum PlayerInputKey {
	INPUT_VECTOR,
}

func _save_state() -> Dictionary:
	return {
		position = position,
	}

func _load_state(state: Dictionary) -> void:
	position = state['position']

func _interpolate_state(old_state: Dictionary, new_state: Dictionary, weight: float) -> void:
	position = lerp(old_state['position'], new_state['position'], weight)

func _get_local_input() -> Dictionary:
	var input_vector = Vector2(
		Input.get_action_strength("player_right") - Input.get_action_strength("player_left"),
		Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
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
	position += input.get(PlayerInputKey.INPUT_VECTOR, Vector2.ZERO) * 8
