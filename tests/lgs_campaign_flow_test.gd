extends SceneTree
## LGS sequential locks and scene registration, with isolated save data.
const IDS: Array[StringName] = [&"seasons", &"bridge", &"pulley", &"turkish", &"history", &"english", &"religion"]
var failures := 0
func _initialize() -> void:
	call_deferred("_run")
func check(label: String, ok: bool) -> void:
	print("%s %s" % ["ok" if ok else "HATA", label])
	if not ok: failures += 1
func _run() -> void:
	var campaign = root.get_node("Campaign")
	var old_path: String = campaign.save_path
	var old_completed: Dictionary = campaign.completed_ids.duplicate()
	var old_flags: Dictionary = campaign.story_flags.duplicate()
	campaign.save_path = "user://meridian_lgs_test.cfg"
	campaign.completed_ids.clear()
	campaign.story_flags.clear()
	campaign.story_flags[&"intro_seen"] = true
	var center = load("res://scenes/control_center.tscn").instantiate()
	root.add_child(center)
	await process_frame
	center._select_route(&"lgs")
	var actual: Array[StringName] = []
	for definition in center.visible_missions: actual.append(definition.id)
	check("yedi görev ve sıra korunur", actual == IDS)
	for index in IDS.size():
		var definition = center._mission_by_id(IDS[index])
		check("%s sahnesi bağlı" % IDS[index], definition != null and definition.scene != null)
		check("%s önceki onarımdan sonra açılır" % IDS[index], center._mission_available(definition))
		if index + 1 < IDS.size():
			check("sonraki görev kilitli", not center._mission_available(center._mission_by_id(IDS[index + 1])))
		campaign.mark_completed(IDS[index], &"lgs")
	check("LGS ilerlemesi sınıfları tamamlamaz", not campaign.is_completed(&"seasons", &"class"))
	center._select_route(&"class")
	for id in [&"newton", &"projectile", &"collision"]:
		var definition = center._mission_by_id(id)
		check("%s sınıflardan oynanabilir" % id, definition != null and definition.routes.has("class") and center._mission_available(definition))
	center.queue_free()
	await process_frame
	campaign.completed_ids.assign(old_completed)
	campaign.story_flags.assign(old_flags)
	campaign.save_path = old_path
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://meridian_lgs_test.cfg"))
	print("BAŞARISIZ: %d" % failures)
	quit(failures)
