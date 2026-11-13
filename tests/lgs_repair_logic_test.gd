extends SceneTree
var failures := 0
func _initialize() -> void:
	call_deferred("_run")
func check(label: String, ok: bool) -> void:
	print("%s %s" % ["ok" if ok else "HATA", label])
	if not ok: failures += 1
func _run() -> void:
	for kind in ["bridge", "turkish", "english", "religion"]:
		var m = load("res://stations/%s/mission.tscn" % kind).instantiate()
		root.add_child(m)
		var completed := [0]
		m.completed.connect(func() -> void: completed[0] += 1)
		m._finish()
		check(kind + " cannot seal before recovery", completed[0] == 0)
		if kind != "bridge":
			m._begin_test(); m._advance_phase()
			m._choose_evidence(1 - int(m.PACK[kind].steps[0].answer), 0)
			check(kind + " wrong evidence keeps the fault visible", m.phase == 2 and m.fault_visible)
			m._choose_evidence(int(m.PACK[kind].steps[0].answer), 0)
			m._choose_evidence(int(m.PACK[kind].steps[1].answer), 1)
			m._choose_repair(int(m.PACK[kind].steps[2].answer))
		else:
			m.phase = 3; m._show_stage()
			var edit: LineEdit = m.action_buttons.get_child(0)
			edit.text = "(a+b)²=a²+b²"
			m._submit_formula(edit, m.PACK.bridge)
			check("bridge missing rectangles is rejected", m.phase == 3)
			edit.text = "(a+b)²=a²+ab+ab+b²"
			m._submit_formula(edit, m.PACK.bridge)
		check(kind + " independent recovery is required", m.phase == 4 and completed[0] == 0)
		for attempt in 3:
			m._choose_rescue("0" if kind == "bridge" else 1)
		check(kind + " exhausted recovery is locked", m.locked and m.attempts == 3 and completed[0] == 0)
		m._choose_rescue("12" if kind == "bridge" else 0)
		check(kind + " cannot bypass exhaustion", completed[0] == 0 and m.phase == 4)
		m._restart_after_failure()
		check(kind + " restart restores visible crisis", m.phase == 0 and m.fault_visible and m.attempts == 0)
		m.phase = 4; m._show_stage()
		m._choose_rescue("12" if kind == "bridge" else 0)
		m._finish(); m._finish()
		check(kind + " seal emitted once after success", completed[0] == 1)
		m.queue_free()
		await process_frame
	await process_frame
	print("BAŞARISIZ: %d" % failures)
	quit(failures)
