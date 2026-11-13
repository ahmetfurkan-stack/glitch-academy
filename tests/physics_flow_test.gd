extends Node
const Photo = preload("res://stations/photoelectric/photo_sim.gd")
var failures := 0
func check(label: String, ok: bool) -> void:
	print("%s %s" % ["ok" if ok else "HATA", label])
	if not ok: failures += 1
func _ready() -> void:
	Engine.time_scale = 20.0
	await photoelectric()
	await waves()
	Engine.time_scale = 1.0
	print("BAŞARISIZ: %d" % failures)
	get_tree().quit(failures)
func photoelectric() -> void:
	var m = load("res://stations/photoelectric/mission.tscn").instantiate()
	var done := [0]
	m.completed.connect(func() -> void: done[0] += 1)
	add_child(m)
	m._on_action()
	m._on_action()
	check("foto: gözlem olmadan teşhis yok", m.step == m.Step.TEST)
	m._f = 4.3e14; m._i = 1.0; m._after_change()
	m._anchor_f = 9e14; m._anchor_i = 0.3; m._anchor_k = Photo.k_max(9e14, 2.07)
	m._f = 9e14; m._i = 0.9; m._after_change()
	m._anchor_f = 9e14; m._anchor_i = 0.9; m._anchor_k = Photo.k_max(9e14, 2.07)
	m._f = 12e14; m._after_change()
	m._on_action()
	m._on_action()
	check("foto: kanıtsız Enter ilerletmez", m.step == m.Step.REASON)
	m.apply_diagnosis_record(0, &"frequency")
	m.apply_diagnosis_record(1, &"frequency")
	m._on_action()
	m.entry.text = "0,5"; m._on_action()
	check("foto: yanlış eşik ilerletmez", m.step == m.Step.MEASURE)
	m.entry.text = "5"; m._on_action()
	for attempt in 3:
		m.entry.text = "4,5"
		(m.tools.get_node("IntensityEntry") as LineEdit).text = "100"
		m._on_action()
		m._on_action()
		await get_tree().create_timer(2.3).timeout
	check("foto: üç hak sonrası sessiz yenileme yok", m._tries == 0 and m.step == m.Step.DONE and done[0] == 0)
	m._on_action()
	check("foto: hak bitince kriz tekrar gerekir", m.step == m.Step.CRISIS)
	m._enter_rescue() # Independent success path; the tested UI path above includes all prerequisites.
	m.entry.text = "8"
	(m.tools.get_node("IntensityEntry") as LineEdit).text = "70"
	m._on_action()
	check("foto: iki fizik koşulu birlikte kapıyı açar", done[0] == 1)
	m.queue_free()
	await get_tree().process_frame
func waves() -> void:
	var m = load("res://stations/waves/mission.tscn").instantiate()
	var done := [0]
	m.completed.connect(func() -> void: done[0] += 1)
	add_child(m)
	m._on_action()
	m._seen_single = true
	m._view().frequency = 4.0; m._after_change()
	m._view().frequency = 6.0; m._after_change()
	m._on_action()
	m._on_action()
	check("dalga: kanıt olmadan Enter ilerletmez", m.step == m.Step.REASON)
	m.apply_diagnosis_record(0, &"path")
	m.apply_diagnosis_record(1, &"path")
	m._on_action()
	m.entry.text = "1,5"; m._on_action()
	check("dalga: eski hazır yanıt yeni ölçümde geçmez", m.step == m.Step.MEASURE)
	m.entry.text = "1"; m._on_action()
	check("dalga: kontrol oranı onarıldı", m.step == m.Step.RESCUE)
	for value in ["4", "2", "3"]:
		m.entry.text = value; m._on_action()
	check("dalga: hak bitince uygulama kilitlenir", m._tries == 0 and m.step == m.Step.DONE and done[0] == 0)
	m._on_action()
	check("dalga: krize geri dönüş", m.step == m.Step.CRISIS)
	m._enter_rescue()
	m.entry.text = "6"; m._on_action()
	check("dalga: iki sensör koşulu birlikte sağlanır", done[0] == 1)
	m.queue_free()
	await get_tree().process_frame
