# Global.gd
extends Node

var current_shape = "circle"  # 初期形状は丸
var rotation_speed = 1       # 初期の回転速度
var line_color = Color(0, 0, 0)  # 初期の線の色（黒）
var pen_size = 2.0              # 初期のペンの太さ
var pen_shape = "circle"        # 初期のペンの形状

# レコーディング関連
var is_recording = false  # レコーディング状態を保持
var events = []  # 記録するイベントのリスト
var start_time = 0  # 記録開始時間


# レコーディング開始
func start_recording():
	is_recording = true
	start_time = Time.get_ticks_msec()
	events.clear()
	print("Recording started")

# レコーディング停止
func stop_recording():
	is_recording = false
	save_recording("res://recording.json")
	print("Recording stopped and saved")

# イベントを追加する関数
func add_event(event_type, params = {}):
	if is_recording:
		var event = {
			"type": event_type,
			"time": Time.get_ticks_msec() - start_time
		}
		# params の内容を event に手動で追加
		for key in params.keys():
			event[key] = params[key]
		events.append(event)

# 記録内容をJSONファイルに保存する
func save_recording(path):
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		# JSON.printを使用してインデント付きのJSON文字列を生成
		var formatted_json = format_json(events, 4)  # 4つのスペースでインデント
		file.store_string(formatted_json)
		file.close()
		print("Recording saved to:", path)
	else:
		print("Failed to open file for writing:", path)

# JSONをインデント付きに整形する関数
func format_json(data, indent_level = 4) -> String:
	#print("It's format_json")
	var json_text = JSON.stringify(data)
	var formatted_text = ""
	var indent = 0
	for char in json_text:
		if char == '{' or char == '[':
			formatted_text += char + "\n" + " ".repeat(indent + indent_level)
			indent += indent_level
		elif char == '}' or char == ']':
			indent -= indent_level
			formatted_text += "\n" + " ".repeat(indent) + char
		elif char == ',':
			formatted_text += char + "\n" + " ".repeat(indent)
		else:
			formatted_text += char
	#print(formatted_text)
	return formatted_text
