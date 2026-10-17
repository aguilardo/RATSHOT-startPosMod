extends ModScript

var controller_script: GDScript


func initialize_mod() -> void:
	print("[startPos Mod] Initializing...")

	controller_script = load(
		"res://Mods/speedrun_tools/speedrun_tools_controller.gd"
	) as GDScript

	if controller_script == null:
		push_error("[startPos Mod] Could not load controller!")
		return
		
	#wait for plr
	Global.player_ready.connect(_on_player_ready)

	print("[startPos Mod] Initialized!")


func _on_player_ready(player: Player) -> void:
	if not is_instance_valid(player):
		return

	var controller = controller_script.new()

	controller.player = player
	player.add_child(controller)

	print("[startPos Mod] Controller attached to player!")
