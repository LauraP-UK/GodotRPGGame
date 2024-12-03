extends Node
class_name InputController

static var input_controller:InputController = null;

func _init():
	if (input_controller != null): return;
	input_controller = self;

static func i() -> InputController:
	return input_controller;

func _process(delta):
	var press_event: KeyPressEvent;
	var release_event: KeyReleaseEvent;
	
	if Input.is_action_pressed("ui_up"):
		press_event = KeyPressEvent.new("W");
	elif Input.is_action_pressed("ui_left"):
		press_event = KeyPressEvent.new("A");
	elif Input.is_action_pressed("ui_down"):
		press_event = KeyPressEvent.new("S");
	elif Input.is_action_pressed("ui_right"):
		press_event = KeyPressEvent.new("D");
	
	if Input.is_action_just_released("ui_up"):
		release_event = KeyReleaseEvent.new("W");
	elif Input.is_action_just_released("ui_left"):
		release_event = KeyReleaseEvent.new("A");
	elif Input.is_action_just_released("ui_down"):
		release_event = KeyReleaseEvent.new("S");
	elif Input.is_action_just_released("ui_right"):
		release_event = KeyReleaseEvent.new("D");
	
	if (press_event) : EventManager.fire_event(press_event);
	if (release_event) : EventManager.fire_event(release_event);
