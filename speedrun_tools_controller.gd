extends Node

var player: Player

var startpos: Vector2
var has_startpos: bool = false

var marker: Node2D


# startpos indicator
class StartPosMarker extends Node2D:
	var pulse_time: float = 0.0

	func _process(delta: float) -> void:
		pulse_time += delta #move idnicator
		queue_redraw()

	func _draw() -> void:
		var pulse = (sin(pulse_time * 3.0) + 1.0) / 2.0

		var radius = 15.0 + pulse * 4.0
		var alpha = 0.55 + pulse * 0.4

		var cyan = Color(0.1, 0.9, 1.0, alpha)
		var white = Color(1.0, 1.0, 1.0, 0.95)

		draw_arc(
			Vector2.ZERO,
			radius,
			0.0,
			TAU,
			48,
			cyan,
			2.5
		)

		var size = 7.0

		var diamond = PackedVector2Array([
			Vector2(0, -size),
			Vector2(size, 0),
			Vector2(0, size),
			Vector2(-size, 0)
		])

		draw_colored_polygon(diamond, Color(0.05, 0.65, 0.9, 0.9))

		for i in range(diamond.size()):
			draw_line(
				diamond[i],
				diamond[(i + 1) % diamond.size()],
				white,
				1.5
			)

		draw_line(Vector2(-25, 0), Vector2(-11, 0), cyan, 2.0)
		draw_line(Vector2(11, 0), Vector2(25, 0), cyan, 2.0)
		draw_line(Vector2(0, -25), Vector2(0, -11), cyan, 2.0)
		draw_line(Vector2(0, 11), Vector2(0, 25), cyan, 2.0)

		var font = ThemeDB.fallback_font

		if font:
			draw_string(
				font,
				Vector2(0, -34),
				"STARTPOS",
				HORIZONTAL_ALIGNMENT_CENTER,
				-1,
				16,
				white
			)


func _ready() -> void:
	print("[startPos Mod] Ready!")


func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return

	if not event.pressed or event.echo:
		return

	if not is_instance_valid(player):
		return

	match event.keycode:
		KEY_1:
			save_startpos()

		KEY_Q:
			load_startpos()


func save_startpos() -> void:
	startpos = player.global_position
	has_startpos = true

	# Create the marker only once.
	if not is_instance_valid(marker):
		marker = StartPosMarker.new()
		marker.name = "SpeedrunStartPosMarker"
		marker.z_index = 67

		var world = player.get_tree().current_scene

		if world == null:
			push_error("[startPos Mod] No current scene!")
			marker.queue_free()
			marker = null
			return

		world.add_child(marker)

	marker.global_position = startpos


func load_startpos() -> void:
	if not has_startpos:
		return

	if not is_instance_valid(marker):
		return

	#force cheats
	Global.usedCheats = true
	
	player.global_position = startpos

	# stop the player's movement
	if "velocity" in player:
		player.velocity = Vector2.ZERO
