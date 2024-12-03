extends Controller

class_name RoamerAI

func update_controller(delta: float) -> void:
	if (RandF.rand_chance_in_I(1, 150)):
		var random_direction: DirectionsType = RandF.rand_from(Directions.get_cardinal());
		if (!can_move(random_direction) || RandF.rand_chance_in_I(1, 4)):
			set_idle(random_direction);
			return;
		
		try_move_actor(random_direction);
