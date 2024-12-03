extends Node
class_name Controllers

enum SIMPLE_TYPE {PLAYER, ROAMER, SPINNER, STATIC}

static var PLAYER: ControllerE = ControllerE.create("Player", PlayerController, SIMPLE_TYPE.PLAYER);
static var ROAMER: ControllerE = ControllerE.create("Roamer", RoamerAI, SIMPLE_TYPE.ROAMER);
static var SPINNER: ControllerE = ControllerE.create("Spinner", SpinnerAI, SIMPLE_TYPE.SPINNER);
static var STATIC: ControllerE = ControllerE.create("Static", StaticAI, SIMPLE_TYPE.STATIC);

static func get_all() -> Array[ControllerE]:
	return [PLAYER, ROAMER, SPINNER, STATIC];

static func get_by_name(controller_name: String) -> GDScript:
	for controller in get_all():
		if (controller.controller_name.to_upper() == controller_name.to_upper()):
			return controller.controller_class;
	return null;

static func get_by_simple(simple_type:SIMPLE_TYPE) -> GDScript:
	for controller in get_all():
		if (controller.simple_type == simple_type): return controller.controller_class;
	return null;
