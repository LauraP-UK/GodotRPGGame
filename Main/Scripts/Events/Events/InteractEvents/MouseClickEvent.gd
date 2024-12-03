extends Event

class_name MouseClickEvent

var button: int;
var is_pressed: bool;

func _init(button: int, is_pressed: bool):
	self.button = button;
	self.is_pressed = is_pressed;


static func get_event_id() -> String:
	return "MouseClickEvent";
