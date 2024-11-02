extends Button


func _ready():
	# ボタンが押されたときのシグナルを接続
	connect("pressed", Callable(self, "_on_clear_button_pressed"))

func _on_clear_button_pressed():
	# LineDrawerのクリア関数を呼び出し
	get_tree().call_group("drawable_nodes", "clear_drawings")
