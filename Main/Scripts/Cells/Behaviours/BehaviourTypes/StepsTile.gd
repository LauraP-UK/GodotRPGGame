extends TileBehaviour
class_name StepsTile

var top: int = 0;
var bottom: int = 0;

static var enter_from: Dictionary = {};

func _init(top: int, bottom: int):
	self.top = top;
	self.bottom = bottom;

func _can_step_on(actor: Actor, entering_direction: DirectionsType) -> bool:
	return true

func _can_step_off(actor: Actor, leaving_direction: DirectionsType) -> bool:
	return true;

func _on_step_on(actor: Actor, entering_direction: DirectionsType) -> void:
	if (entering_direction == Directions.NORTH || entering_direction == Directions.SOUTH):
		enter_from[actor] = entering_direction;

func _on_step_off(actor: Actor, leaving_direction: DirectionsType) -> void:
	if (leaving_direction == Directions.NORTH && enter_from[actor] == Directions.NORTH):
		actor.storey += (top * GameManager.STOREY_MULTIPLIER);
	elif (leaving_direction == Directions.SOUTH && enter_from[actor] == Directions.SOUTH):
		actor.storey += (bottom * GameManager.STOREY_MULTIPLIER);
