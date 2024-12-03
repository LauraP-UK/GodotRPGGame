extends Controller

class_name StaticAI

func update_controller(delta: float) -> void:
	set_idle(owner_actor.current_direction);
