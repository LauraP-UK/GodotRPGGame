extends Node
class_name ControllerE

var controller_name: String = "";
var controller_class: GDScript = null;
var simple_type: Controllers.SIMPLE_TYPE;

func _init(controller_name: String, controller_class: GDScript, simple_type: Controllers.SIMPLE_TYPE):
	self.controller_name = controller_name;
	self.controller_class = controller_class;
	self.simple_type = simple_type;

static func create(controller_name: String, controller_class: GDScript, simple_type: Controllers.SIMPLE_TYPE) -> ControllerE:
	return ControllerE.new(controller_name, controller_class, simple_type);
