extends Actor

class_name Player

var camera: Camera2D = null;

func _ready() -> void:
	super._ready();
	camera = Camera2D.new();
	add_child(camera);
	if (!camera.is_current()): camera.make_current();
	camera.position_smoothing_enabled = false;
	#camera.position_smoothing_speed = 100.0;

func snap_overlay(overlay: Overlay):
	if (overlay == null): return;
	camera.add_child(overlay);
	var viewport_size:Vector2 = get_viewport().size;
	overlay.position = Vector2(-viewport_size.x / 2, -viewport_size.y / 2);
	overlay.z_index = 4000;

func remove_overlay(overlay: Overlay):
	if (overlay == null): return;
	if (overlay.get_parent() != camera): return;
	overlay.queue_free();
