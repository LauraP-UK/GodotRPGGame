extends Controller

class_name SpinnerAI

var counter: float = 0.0;

func update_controller(delta: float) -> void:
	counter += delta;
	
	if (counter >= 1.0):
		counter = 0.0;
		set_idle(Directions.get_cw(owner_actor.current_direction));
