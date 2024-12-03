extends Node
class_name SoftLoadData

var to_load:Dictionary = {};

func add_or_compute(path:String, data_node:SoftLoadDataNode):
	to_load[path] = data_node;

func load_levels():
	var controller:LevelController = LevelController.i();
	var current_level:Level = controller.current_level;
	
	for file_path:String in to_load.keys():
		var node:SoftLoadDataNode = to_load.get(file_path);
		var soft_level:Level = controller.load_level(file_path, false, false, node);
