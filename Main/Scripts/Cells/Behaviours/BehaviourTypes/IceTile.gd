extends TileBehaviour
class_name IceTile

func _can_step_on(actor: Actor, entering_direction: DirectionsType) -> bool:
	return true;

func _can_step_off(actor: Actor, leaving_direction: DirectionsType) -> bool:
	return true;

func _on_step_on(actor: Actor, entering_direction: DirectionsType) -> void:
	actor.animation_state = AnimationStates.SLIDING;
	actor.set_walking_animation();
	var next_tile: TileBehaviour = actor.controller.get_tile_behaviour(entering_direction.get_relative(coords));
	
	if (next_tile.can_step_on(actor, entering_direction)):
		actor.controller.queue_movement(entering_direction);
	else: actor.animation_state = AnimationStates.DEFAULT;

func _on_step_off(actor: Actor, leaving_direction: DirectionsType) -> void:
	pass;
