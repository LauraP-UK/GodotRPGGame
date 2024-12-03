extends TileBehaviour

class_name OpenTile

func _can_step_on(actor: Actor, entering_direction: DirectionsType) -> bool:
	return true;

func _can_step_off(actor: Actor, leaving_direction: DirectionsType) -> bool:
	return true;

func _on_step_on(actor: Actor, entering_direction: DirectionsType) -> void:
	actor.animation_state = AnimationStates.DEFAULT;

func _on_step_off(actor: Actor, leaving_direction: DirectionsType) -> void:
	pass;
