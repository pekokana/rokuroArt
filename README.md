# rokuroArt

**rokuroArt**は、**Godot 4.2.1**で開発された、回転する円盤上に線を描画するツールです。ユーザーはペンの設定やディスクの形状を変更しながら描画を行え、全ての操作を記録することができます。記録したデータはJSONファイルにエクスポート可能です。

**rokuroArt** is a disk-based drawing tool developed in **Godot 4.2.1**. Users can draw lines on a rotating disk, customize pen settings, and change disk shapes while recording all actions. The recorded data can be exported to a JSON file.

---

## 特徴 / Features

- **円盤上に線を描画** - ユーザーは円盤を回転させながら線を描けます。
- **ディスクの回転** - 矢印キーでディスクを回転させ、回転速度も調整可能。
- **ペンの設定** - ペンの形状、サイズ、色を変更。
- **ディスクの形状変更** - 複数のディスク形状から選択可能。
- **アクションの記録** - すべての操作をJSON形式で記録。

---

- **Line Drawing on Disk** - Users can draw on a rotating disk.
- **Disk Rotation** - Rotate the disk using arrow keys with adjustable speed.
- **Pen Customization** - Change pen shape, size, and color.
- **Disk Shape Customization** - Select from multiple disk shapes.
- **Action Recording** - Record all actions and save them in JSON format.

---

## セットアップ / Setup

1. **リポジトリをクローン** / **Clone the repository**:
   ```bash
   git clone https://github.com/pekokana/rokuroArt.git
   cd rokuroArt
   ```

2. **Godotでプロジェクトを開く** / **Open the project in Godot**:
   - Godot 4.2.1を起動し、プロジェクトを選択して開きます。
   - Launch Godot 4.2.1 and open the project.

3. **プロジェクトを実行** / **Run the project**:
   - **再生ボタン**をクリックしてプロジェクトを実行します。
   - Press the **Play** button in Godot to start the application.

---

## 使い方 / Usage

### 基本操作 / Basic Usage

1. **円盤上に描画**:
   - 矢印キーでディスクを回転させ、ドラッグして線を描画します。
2. **ペン設定**:
   - UIで**ペンの形状**、**サイズ**、**色**を調整します。
3. **ディスク形状変更**:
   - UIからディスクの形状を変更できます。

---

1. **Draw on Disk**:
   - Rotate the disk with arrow keys and drag to draw lines.
2. **Customize Pen Settings**:
   - Adjust **pen shape**, **size**, and **color** from the UI.
3. **Change Disk Shape**:
   - Select different disk shapes from the UI.

---

### 記録 / Recording

1. **記録の開始**:
   - **「Start Recording」**ボタンをクリックして記録を開始します。
   - 記録中にペンの設定、ディスクの形状、回転などの操作が保存されます。
2. **記録の停止と保存**:
   - もう一度**「Start Recording」**ボタンをクリックして記録を停止します。
   - 記録データは自動的にJSONファイルに保存されます。

---

1. **Start Recording**:
   - Click the **Start Recording** button to begin recording.
   - Actions such as pen settings, disk shape, and rotation are saved during recording.
2. **Stop and Save Recording**:
   - Click **Start Recording** again to stop recording.
   - The recorded data is automatically saved to a JSON file.

---

## JSON構造 / JSON Structure

記録されたJSONファイルには、各操作が以下の形式で時系列で保存されます。

The recorded JSON file stores each action chronologically in the following format:

```json
[
    {
        "type": "initial_state",
        "time": 0,
        "pen_color": "#ff0000",
        "pen_shape": "circle",
        "pen_size": 2,
        "rotation_speed": 1.5
    },
    {
        "type": "draw_line",
        "time": 500,
        "start": [0, 0],
        "end": [10, 10],
        "color": "#ff0000",
        "size": 2
    },
    {
        "type": "rotation_start",
        "time": 1000,
        "direction": "right",
        "rotation_speed": 1.5
    },
    {
        "type": "rotation_update",
        "time": 1500,
        "rotation": 0.5
    },
    {
        "type": "rotation_stop",
        "time": 2000,
        "direction": "right",
        "rotation": 0.5
    }
]
```

---

## コード概要 / Code Overview

### Global.gd

- **記録状態**を管理し、各アクションをイベントとして保存します。
- 主な関数:
  - `start_recording()`: 記録の開始。
  - `stop_recording()`: 記録の終了とファイル保存。
  - `add_event(event_type, params)`: タイムスタンプ付きでイベントを保存。

---

- Manages the **recording state** and stores each action as an event.
- Key Functions:
  - `start_recording()`: Starts recording.
  - `stop_recording()`: Stops recording and saves to file.
  - `add_event(event_type, params)`: Adds an event with a timestamp.

### Disk.gd

- ディスクの**回転と形状の管理**を行います。
- 矢印キー入力を処理し、回転イベント（`rotation_start`、`rotation_stop`、`rotation_update`）を記録します。

---

- Manages **disk rotation and shape**.
- Handles arrow key inputs and records rotation events (`rotation_start`, `rotation_stop`, `rotation_update`).

### LineDrawer.gd

- **描画アクション**を管理し、記録が有効な場合は描画イベントを保存します。

---

- Manages **drawing actions** and logs drawing events when recording is active.

---

## 改善案 / Future Improvements

- **追加の形状サポート** - ペンとディスクにさらに多様な形状を追加。
- **再生機能の追加** - 記録されたJSONファイルをもとに再現するリプレイ機能を実装。
- **GIF/動画出力** - 描画内容をGIFや動画としてエクスポートする機能。

---

- **Support for Additional Shapes** - Add more shapes for pen and disk.
- **Replay Functionality** - Implement replay based on recorded JSON data.
- **GIF/Video Export** - Add functionality to export drawing sessions as GIFs or videos.

---

## ライセンス / License

このプロジェクトはMITライセンスの下で公開されています。

This project is licensed under the MIT License.
