extends Node2D

@export var disk_radius: float = 250.0  # 円盤の半径と同じサイズに設定
var is_drawing = false  # 描画中フラグ
@export var disk_color: Color = Color(1, 1, 1, 0)  # 円盤の色
var current_draw_points = []  # 現在描画中の線のポイント
var all_drawn_paths = []  # 過去に描画された全ての線を保存
var is_rotating = false  # ディスクが回転中かどうかのフラグ
var start_angle = 0.0  # 描画開始時の回転角度
var previous_rotation = 0.0  # 前フレームの回転角度
var initial_click_position = Vector2()  # マウスのクリック位置

# Path2DとPathFollow2Dを準備
var path2d  # Path2Dノード
var path_follow  # PathFollow2Dノード

func _ready():
	add_to_group("drawable_nodes")  # グループに追加
	# Path2DとPathFollow2Dを取得
	path2d = $Path2D
	path_follow = $Path2D/PathFollow2D
	path2d.curve = Curve2D.new()

# クリア関数
func clear_drawings():
	all_drawn_paths.clear()  # 全ての線をクリア
	queue_redraw()  # 再描画

# 形状の更新
func update_shape():
	queue_redraw()

func _process(delta):
	# ディスクの回転の制御
	if Input.is_action_pressed("ui_right"):
		rotation += Global.rotation_speed * delta
		is_rotating = true
	elif Input.is_action_pressed("ui_left"):
		rotation -= Global.rotation_speed * delta
		is_rotating = true
	else:
		is_rotating = false

	# 回転中に描画している場合、基準位置から現在の回転角度に基づいて描画
	if is_drawing and is_rotating:
		# 現在の回転角度と初期位置を基準に計算
		var current_angle = rotation - start_angle
		var rotated_point = initial_click_position.rotated(current_angle)
		current_draw_points.append(rotated_point)
		queue_redraw()
	
# 描画領域の中にいるかどうか確認する関数
func is_inside_shape(point: Vector2) -> bool:
	#return point.length() <= disk_radius
	match Global.current_shape:
		"circle":
			return point.length() <= disk_radius
		"square":
			return abs(point.x) <= disk_radius and abs(point.y) <= disk_radius
		"pentagon":
			var points = []
			for i in range(5):
				var angle = deg_to_rad(360 / 5 * i - 90)
				points.append(Vector2(cos(angle), sin(angle)) * disk_radius)
			return is_point_in_polygon(point, points)
		"hexagon":
			var hexagon_points = []
			for i in range(6):
				var angle = deg_to_rad(360 / 6 * i - 90)
				hexagon_points.append(Vector2(cos(angle), sin(angle)) * disk_radius)
			return is_point_in_polygon(point, hexagon_points)
	return false

# ポリゴン内の判定
func is_point_in_polygon(point: Vector2, polygon: Array) -> bool:
	var inside = false
	var j = polygon.size() - 1
	for i in range(polygon.size()):
		var vertex1 = polygon[i]
		var vertex2 = polygon[j]
		if ((vertex1.y > point.y) != (vertex2.y > point.y)) and (point.x < (vertex2.x - vertex1.x) * (point.y - vertex1.y) / (vertex2.y - vertex1.y) + vertex1.x):
			inside = not inside
		j = i
	return inside

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# 左クリックが押されたとき、円盤内であれば描画開始
			var local_pos = to_local(event.position)
			if is_inside_shape(local_pos):
				# 左クリック押下時に描画を開始
				is_drawing = true
				start_angle = rotation  # 現在の回転角度を基準として保存
				initial_click_position = local_pos  # マウスの位置を保存
				current_draw_points.clear()  # 新しい線のためにポイントをクリア
				path2d.curve.clear_points()  # 新しい線のためにパスをクリア
		else:
			# 左クリックが離されたとき、描画を終了し、現在の線を保存
			if is_drawing and current_draw_points.size() > 1:
				# 現在の線を色と共に保存
				#all_drawn_lines.append({ "color": Global.line_color, "points": current_draw_points.duplicate() })
				# 現在の線を色、太さと共に保存
				all_drawn_paths.append({
					"shape": Global.pen_shape,
					"color": Global.line_color,
					"size": Global.pen_size,
					"points": current_draw_points.duplicate()
				})
				# レコーディング中であれば描画イベントを記録
				if Global.is_recording:
					Global.add_event("draw_line", {
						"points": current_draw_points.duplicate(),
						"color": Global.line_color,
						"size": Global.pen_size,
					})
			# 左クリックが離されたら描画を終了し、ポイントを保存
			is_drawing = false
			current_draw_points.clear()
	elif event is InputEventMouseMotion and is_drawing:
		# マウスのローカル座標を取得して、現在の線のポイントとして追加
		var local_pos = to_local(event.position)
		
		if is_inside_shape(local_pos):
			# ディスクが回転している場合は回転に合わせて座標変換
			if is_rotating:
				# 回転に合わせた座標を計算
				var rotated_point = local_pos.rotated(-rotation)
				current_draw_points.append(rotated_point)
			else:
				# 通常の座標で描画
				current_draw_points.append(local_pos)
			# 一定距離で間引きしてからポイントを追加
			if current_draw_points.size() == 0 or current_draw_points[-1].distance_to(local_pos) > 5:
				current_draw_points.append(local_pos)
				var smooth_points = interpolate_points(current_draw_points)
				path2d.curve.clear_points()  # 古い点をクリア
				for p in smooth_points:
					path2d.curve.add_point(p)  # 補間された点を追加
			queue_redraw()  # 即座に再描画をキューに入れる

# 2点間を補完する関数
func interpolate_points(points: Array) -> Array:
	var smooth_points = []
	for i in range(1, points.size() - 2):
		var p0 = points[i - 1] if i > 0 else points[i]
		var p1 = points[i]
		var p2 = points[i + 1]
		var p3 = points[i + 2] if i + 2 < points.size() else points[i + 1]

		# 各区間で少ない補間点を計算
		for t in range(4):  # 必要に応じて値を調整
			var u = t / 2.0  # 正規化された補間パラメータ
			var interpolated_point = 0.5 * (
				(2 * p1) +
				(-p0 + p2) * u +
				(2 * p0 - 5 * p1 + 4 * p2 - p3) * u * u +
				(-p0 + 3 * p1 - 3 * p2 + p3) * u * u * u
			)
			smooth_points.append(interpolated_point)
   			
	# 最後の点を追加
	smooth_points.append(points[points.size() - 1])
	return smooth_points


# 各ペンの形状に応じたポイント描画
func draw_point_shape(point: Vector2, shape: String, size: float, color: Color):
	match shape:
		"circle":
			draw_circle(point, size / 2, color)
		"square":
			draw_rect(Rect2(point - Vector2(size / 2, size / 2), Vector2(size, size)), color)

func _draw():
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

	for path_data in all_drawn_paths:
		var path_shape = path_data["shape"]
		var path_color = path_data["color"]
		var path_size = path_data["size"]
		var path_points = path_data["points"]

		if path_points.size() > 1:
			for j in range(1, path_points.size()):
				var start_point = path_points[j - 1]
				var end_point = path_points[j]
				draw_line(start_point, end_point, path_color, path_size)

			# 各ポイントの形状を端に描画して滑らかにする
			draw_point_shape(path_points[0], path_shape, path_size, path_color)
			draw_point_shape(path_points[-1], path_shape, path_size, path_color)

	# 現在の線を描画
	if current_draw_points.size() > 1:
		for i in range(1, current_draw_points.size()):
			var start_point = current_draw_points[i - 1]
			var end_point = current_draw_points[i]
			draw_line(start_point, end_point, Global.line_color, Global.pen_size)

		# 現在の線の端に形状を描画
		draw_point_shape(current_draw_points[0], Global.pen_shape, Global.pen_size, Global.line_color)
		draw_point_shape(current_draw_points[-1], Global.pen_shape, Global.pen_size, Global.line_color)
