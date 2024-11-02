extends HSlider


func _ready():
	connect("value_changed", Callable(self, "_on_value_changed"))
	_on_value_changed(value)  # 初期化時に現在の太さを反映

func _on_value_changed(new_value):
	Global.pen_size = new_value
	if Global.is_recording:
		Global.add_event("change_pen_size", { "pen_size": new_value })
	print("Selected Pen Size:", Global.pen_size)
