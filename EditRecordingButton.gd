extends Button


func _ready():
	# ボタンが押されたときのシグナルを接続
	connect("pressed", Callable(self, "_on_record_button_pressed"))

# ボタンのクリックで記録開始/終了を切り替える
func _on_record_button_pressed():
	if Global.is_recording:
		Global.stop_recording()
		text = "Start Recording"
	else:
		Global.start_recording()
		text = "Stop Recording"
