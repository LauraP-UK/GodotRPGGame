@tool
extends Node2D

class_name DataNode

@export var misc_json: String = "{}";

static var ICON_SIZE:int = 16;
var last_pos:Vector2 = Vector2(NAN,NAN);

func process():
	pass;
