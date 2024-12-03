extends TileBehaviour
class_name BridgeTile

var storey_directions: Dictionary = {};

func _init(storey_directions: Dictionary):
	self.storey_directions = storey_directions;

func _can_step_on(actor: Actor, entering_direction: DirectionsType) -> bool:
	var storey: int = actor.storey / GameManager.STOREY_MULTIPLIER;
	var available: Array[DirectionsType] = storey_directions[storey];
	
	return available.has(entering_direction);

func _can_step_off(actor: Actor, leaving_direction: DirectionsType) -> bool:
	var storey: int = actor.storey / GameManager.STOREY_MULTIPLIER;
	var available: Array[DirectionsType] = storey_directions[storey];
	
	return available.has(leaving_direction);

func _on_step_on(actor: Actor, entering_direction: DirectionsType) -> void:
	pass;

func _on_step_off(actor: Actor, leaving_direction: DirectionsType) -> void:
	pass;
