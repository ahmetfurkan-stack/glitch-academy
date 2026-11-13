extends Node
## Real simulated drops: two controlled observations, calibration, independent recovery.
var failures := 0
func check(label: String, condition: bool) -> void:
	print("%s %s" % ["ok" if condition else "HATA", label])
	if not condition: failures += 1
func wait_until(condition: Callable) -> void:
	var deadline := Time.get_ticks_msec() + 8000
	while not condition.call() and Time.get_ticks_msec() < deadline:
		await get_tree().process_frame
	check("beklenen işlem tamamlandı", condition.call())
func _ready() -> void:
	Engine.time_scale = 20.0
	var m = load("res://stations/free_fall/mission.tscn").instantiate()
	var done := [0]
	m.completed.connect(func() -> void: done[0] += 1)
	add_child(m)
	m._on_skip()
	m._on_action()
	await wait_until(func() -> bool: return not m._run_pending)
	check("yalnız vakum kaydı teşhisi açmaz", m._vacuum_equal and not m._air_seen)
	m._enter_reason()
	check("teşhis için iki koşul gerekir", m.step == m.Step.TEST)
	m._stage().set_pressure_target(101.0)
	await wait_until(func() -> bool: return not m._stage().is_pumping())
	m._on_action()
	await wait_until(func() -> bool: return not m._run_pending)
	m._on_action()
	m._on_action()
	check("Enter ile kanıtsız ilerlenemez", m.step == m.Step.REASON)
	m.apply_diagnosis_record(0, &"mass")
	m.apply_diagnosis_record(0, &"gravity")
	check("tek kanıt yeterli değil", not m.evidence_verified)
	m.apply_diagnosis_record(1, &"gravity")
	m._on_action()
	m.entry.text = "10"
	m._on_action()
	check("yanlış ölçüm ilerlemez", m.step == m.Step.MEASURE)
	m.entry.text = "6"
	m._on_action()
	check("kurtarmadan önce onarım", m.step == m.Step.REPAIR and done[0] == 0)
	for index in 2:
		m._on_action()
		m._on_action()
		await wait_until(func() -> bool: return not m._run_pending)
	check("iki kalibrasyon cihazdan ölçüldü", m._calibration_index == 2 and m.entry.editable)
	m.entry.text = "40"
	m._on_action()
	await wait_until(func() -> bool: return not m._run_pending)
	check("yanlış ayar dünyayı onarmaz", m.step == m.Step.REPAIR and not m._stage().gravity_fixed)
	m.entry.text = "50"
	m._on_action()
	await wait_until(func() -> bool: return not m._run_pending)
	check("dünya onarıldı; yeni kapak süresi", m.step == m.Step.RESCUE and m._stage().gravity_fixed and m._stage().door_time == 2.5)
	m.entry.text = "27"
	m._on_action()
	await wait_until(func() -> bool: return not m._run_pending)
	check("eski senaryonun yanıtı yeni görevi geçirmez", done[0] == 0 and m._stage().capsules == 2)
	m.entry.text = "31,25"
	m._on_action()
	await wait_until(func() -> bool: return done[0] > 0)
	m._on_action()
	check("bağımsız uygulama tek mühür üretir", done[0] == 1)
	m.queue_free()
	await get_tree().process_frame
	var exhausted = load("res://stations/free_fall/mission.tscn").instantiate()
	add_child(exhausted)
	exhausted._on_skip()
	exhausted.dial = 50.0
	exhausted._stage().gravity = 10.0
	exhausted._stage().gravity_fixed = true
	exhausted._enter_rescue()
	for attempt in 3:
		exhausted.entry.text = "20"
		exhausted._on_action()
		await wait_until(func() -> bool: return not exhausted._run_pending)
	check("kapsüller tükenince yenilenmez", exhausted._out_of_tries and exhausted._stage().capsules == 0 and exhausted.entry == null)
	exhausted._on_action()
	check("hak bitince onarım ve dünya krize döner", exhausted.step == exhausted.Step.CRISIS and not exhausted._stage().gravity_fixed and exhausted._current_g() == 6.0)
	exhausted.queue_free()
	await get_tree().process_frame
	Engine.time_scale = 1.0
	print("BAŞARISIZ: %d" % failures)
	get_tree().quit(failures)
