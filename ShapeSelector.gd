extends OptionButton

# Called when the node enters the scene tree for the first time.
func _ready():
	add_item("丸形")
	add_item("四角形")
	add_item("五角形")
	add_item("六角形")
	connect("item_selected", Callable(self, "_on_shape_selected"))

func _on_shape_selected(index):
	match index:
		0:
			Global.current_shape = "circle"
		1:
			Global.current_shape = "square"
		2:
			Global.current_shape = "pentagon"
		3:
			Global.current_shape = "hexagon"
	
	# DiskとLineDrawerの更新を呼び出す
	if Global.is_recording:
		Global.add_event("change_disk_shape", { "disk_shape": Global.current_shape })
	get_tree().call_group("drawable_nodes", "update_shape")
