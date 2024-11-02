extends Node2D

@export var disk_radius: float = 250.0  # 円盤の半径
@export var disk_color: Color = Color(1, 1, 1)  # 円盤の色

var is_rotating_left = false  # 左回転中のフラグ
var is_rotating_right = false  # 右回転中のフラグ

# Called when the node enters the scene tree for the first time.
func _ready():
	# 初期位置をビューポートの中央に設定
	#position = get_viewport_rect().size / 2 - Vector2(disk_radius, disk_radius)
	add_to_group("drawable_nodes")

# 形状の更新
func update_shape():
	queue_redraw()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	## 回転の制御：右矢印キーで右回転、左矢印キーで左回転
	#if Input.is_action_pressed("ui_right"):
		#rotation += Global.rotation_speed * delta
	#elif Input.is_action_pressed("ui_left"):
		#rotation -= Global.rotation_speed * delta

	# 左右キーが押されているかどうかを確認
	if Input.is_action_pressed("ui_right"):
		if !is_rotating_right:
			is_rotating_right = true
			Global.add_event("rotation_start", { "direction": "right", "rotation_speed": Global.rotation_speed })
		rotation += Global.rotation_speed * delta
		Global.add_event("rotation_update", { "direction": "right", "rotation": rotation, "time": Time.get_ticks_msec() })
	else:
		if is_rotating_right:
			is_rotating_right = false
			Global.add_event("rotation_stop", { "direction": "right", "rotation": rotation })

	if Input.is_action_pressed("ui_left"):
		if !is_rotating_left:
			is_rotating_left = true
			Global.add_event("rotation_start", { "direction": "left", "rotation_speed": Global.rotation_speed })
		rotation -= Global.rotation_speed * delta
		Global.add_event("rotation_update", { "direction": "left", "rotation": rotation, "time": Time.get_ticks_msec() })
	else:
		if is_rotating_left:
			is_rotating_left = false
			Global.add_event("rotation_stop", { "direction": "left", "rotation": rotation })



func _draw():
	## 円盤の描画（形状や背景色を設定）
	#draw_circle(Vector2.ZERO, disk_radius, disk_color)  # 中心を基準に円を描画
	#draw_circle(Vector2.ZERO, disk_radius, Color.WHITE)  # 外枠
	match Global.current_shape:
		"circle":
			draw_circle(Vector2.ZERO, disk_radius, disk_color)
			# 外枠用の円を描画（少し大きくする）
			draw_circle(Vector2.ZERO, disk_radius + 2, disk_color)
		"square":
			var size = disk_radius * 2
			draw_rect(Rect2(-disk_radius, -disk_radius, size, size), disk_color)
			draw_rect(Rect2(-disk_radius, -disk_radius, size, size), disk_color, false, 2)
		"pentagon":
			var points = []
			for i in range(5):
				var angle = deg_to_rad(360 / 5 * i - 90)
				points.append(Vector2(cos(angle), sin(angle)) * disk_radius)
			draw_polygon(points, [disk_color])
			for i in range(5):
				draw_line(points[i], points[(i + 1) % 5], disk_color, 2)
		"hexagon":
			var points = []
			for i in range(6):
				var angle = deg_to_rad(360 / 6 * i - 90)  # 各頂点の角度を設定
				points.append(Vector2(cos(angle), sin(angle)) * disk_radius)
			draw_polygon(points, [disk_color])  # 六角形の塗りつぶし
			for i in range(6):
				draw_line(points[i], points[(i + 1) % 6], disk_color, 2)  # 外枠を描画
