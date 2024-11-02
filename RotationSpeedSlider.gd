extends HSlider


func _ready():
	connect("value_changed", Callable(self, "_on_value_changed"))
	_on_value_changed(value)  # 初期化時に現在の値を反映

func _on_value_changed(new_value):
	Global.rotation_speed = new_value
	if Global.is_recording:
		Global.add_event("change_rotation_speed", { "rotation_speed": new_value })
	print("Rotation Speed set to:", Global.rotation_speed)
