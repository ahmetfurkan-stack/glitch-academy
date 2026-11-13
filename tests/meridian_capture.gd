extends SceneTree
var output := "/tmp/meridian-review"
var enlarged := false
var detail := false
func _initialize() -> void:
	call_deferred("_run")
func _run() -> void:
	detail = OS.get_cmdline_user_args().has("detail")
	enlarged = OS.get_cmdline_user_args().has("130")
	if enlarged: output += "-130"
	if detail: output += "-detail"
	DirAccess.make_dir_recursive_absolute(output)
	root.size = Vector2i(1280, 720)
	for kind in ["newton", "projectile", "collision", "free_fall", "waves", "photoelectric", "turkish", "bridge"]:
		var mission = load("res://stations/%s/mission.tscn" % kind).instantiate()
		mission.theme = root.theme
		root.add_child(mission)
		await process_frame
		await process_frame
		if kind in ["newton", "projectile", "collision"]:
			mission._on_skip()
			mission._on_action()
			mission._elapsed = 2.8
			mission._process(0.0)
			if detail:
				mission._on_action()
				mission._elapsed = 2.8
				mission._process(0.0)
				mission._on_action()
		elif kind == "turkish":
			mission._begin_test()
			mission._advance_phase()
		if enlarged: _scale_text(mission)
		await create_timer(0.3).timeout
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(output + "/" + kind + ".png")
		mission.queue_free()
		await process_frame
	await process_frame
	await process_frame
	quit()


func _scale_text(node: Node) -> void:
	if node is Label or node is Button or node is LineEdit:
		node.add_theme_font_size_override("font_size", roundi(node.get_theme_font_size("font_size") * 1.3))
	for child in node.get_children(): _scale_text(child)
