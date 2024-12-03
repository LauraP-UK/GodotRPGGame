extends TileBehaviour

class_name SolidTile

func _can_step_on(actor: Actor, entering_direction: DirectionsType) -> bool:
	return false;

func _can_step_off(actor: Actor, leaving_direction: DirectionsType) -> bool:
	return true;
