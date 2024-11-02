extends OptionButton


func _ready():
	add_item("丸形")
	add_item("四角形")
	connect("item_selected", Callable(self, "_on_shape_selected"))

func _on_shape_selected(index):
	match index:
		0:
			Global.pen_shape = "circle"
		1:
			Global.pen_shape = "square"
		2:
			Global.pen_shape = "star"
	if Global.is_recording:
		Global.add_event("change_pen_shape", { "pen_shape": Global.pen_shape })
	print("Selected Pen Shape:", Global.pen_shape)
