extends ColorPickerButton


func _ready():
	connect("color_changed", Callable(self, "_on_color_changed"))
	_on_color_changed(color)  # 初期色を設定

# 色が選択されたときにGlobalの値を更新
func _on_color_changed(picked_color):
	Global.line_color = picked_color
	if Global.is_recording:
		Global.add_event("change_pen_color", { "pen_color": picked_color })
	print("Selected Line Color:", Global.line_color)
