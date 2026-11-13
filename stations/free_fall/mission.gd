extends "res://scripts/physics/experiment_mission.gd"
## MERİDYEN'in çekim ayarı: gözlem, iki noktalı onarım, yeni sürede kurtarma.
const Stage = preload("res://stations/free_fall/fall_stage.gd")
const Fall = preload("res://stations/free_fall/fall_sim.gd")
const TEST_HEIGHT := 20.0
const TARGET_TIME := 2.5
const HEALTHY_G := 10.0
const BROKEN_DIAL := 25.0
enum Step { CRISIS, TEST, REASON, MEASURE, REPAIR, RESCUE, DONE }
var step := Step.CRISIS
var dial := BROKEN_DIAL
var _vacuum_equal := false
var _air_seen := false
var _vacuum_record := ""
var _air_record := ""
var _drop_pressure := 0.0
var _calibration_index := 0
var _run_pending := false
var _out_of_tries := false
var _air_control: HSlider
var _trial_serial := 0

func _make_stage() -> Control:
	var view := Stage.new()
	view.landed.connect(_on_landed)
	return view
func _stage() -> Stage:
	return stage as Stage
func _current_g() -> float:
	return Fall.gravity_for_dial(dial)
func _begin() -> void:
	step_total = 6
	_enter_crisis()
func _enter_crisis() -> void:
	_trial_serial += 1
	step = Step.CRISIS
	dial = BROKEN_DIAL
	_run_pending = false
	_out_of_tries = false
	var view := _stage()
	view.rewind()
	view.gravity = _current_g()
	view.gravity_fixed = false
	view.gravity_label = ""
	view.pressure = 0.0
	view.pressure_target = 0.0
	view.door_enabled = true
	view.door_time = 3.0
	view.show_expectation = true
	view.capsules = 3
	view.log_rows.clear()
	view.set_bodies([&"capsule"])
	view.set_release_height(45.0)
	screen(0, "Kriz", "Kapsül kapak kapandıktan sonra geliyor. MERİDYEN'in ayarını incele.", "", "Oda vakumda. MERİDYEN kontrolcüsü kapsülün kapak açıkken ulaşacağını öngördü; ölçüm farklı.")
	hud.skip.show()
	view.release([&"capsule"])
func _on_skip() -> void:
	if step == Step.CRISIS:
		_enter_test()
func _enter_test() -> void:
	step = Step.TEST
	_vacuum_equal = false
	_air_seen = false
	var view := _stage()
	view.rewind()
	view.door_enabled = false
	view.log_rows.clear()
	view.set_bodies([&"steel", &"foam"])
	view.set_release_height(TEST_HEIGHT)
	screen(1, "Sına", "İki topu vakumda ve hava açıkken bırak; süreleri karşılaştır.", "Bırak", "Yalnız basıncı değiştir. Topların kütlesi, bırakma yüksekliği ve ilk hızı aynı deney boyunca sabittir.")
	add_power("Sar", "Aynı koşullarla denemeyi yeniden oynat", _replay_drop)
	add_power("Yavaşlat", "Ölçüm zamanı değişmez; hareket yavaş gösterilir", func(on: bool) -> void: view.time_scale = 0.25 if on else 1.0, true)
	_air_control = add_slider("Basınç", 0, Fall.ATMOSPHERE, view.pressure_target, 1, func(value: float) -> void: view.set_pressure_target(value), 220)
func _on_test_landed(results: Dictionary) -> void:
	_run_pending = false
	_air_control.editable = true
	var steel: float = results[&"steel"].time
	var foam: float = results[&"foam"].time
	var line := "%d kPa: çelik %s; sünger %s" % [roundi(_drop_pressure), _stage().seconds_text(steel), _stage().seconds_text(foam)]
	_stage().log_rows.append(line)
	if _drop_pressure < 3.0 and absf(steel - foam) < 0.01:
		_vacuum_equal = true
		_vacuum_record = line
	elif _drop_pressure >= 3.0:
		_air_seen = true
		_air_record = line
	say("Ölçüm kaydedildi; iki koşulun sürelerini karşılaştır.")
	hud.set_action("Kanıtları incele" if _vacuum_equal and _air_seen else "Bırak", true)
func _enter_reason() -> void:
	if not (_vacuum_equal and _air_seen): return
	step = Step.REASON
	screen(2, "Teşhis", "Kayıtları çeliştikleri MERİDYEN ayarına taşı.")
	show_evidence_diagnosis([_vacuum_record, _air_record], {
		&"mass": "Test topları: farklı kütleler",
		&"air": "Kriz kaydı: oda vakumda",
		&"gravity": "Çekim dengeleyici: hedef ivme sağlanıyor"
	}, &"gravity", _on_reason)
func _on_reason(key: StringName) -> void:
	if key == &"gravity" and evidence_verified:
		clear_tools()
		hud.set_action("İvmeyi ölç", true)
		say("İki ölçüm bu ayarla çelişti; mühür açıldı.", GOOD)
	else:
		say("Bu ayar kayıtla tutarlı; iki koşulu karşılaştır.", BAD)
func _enter_measure() -> void:
	step = Step.MEASURE
	screen(3, "Düzelt", "Cetvel ve vakum kaydından g değerini hesapla.", "Onayla", "İlk hızsız düşüş: h = ½gt². Birimleri metre ve saniye olarak kullan.")
	add_entry("İvme (m/s²)")
func _check_measure() -> void:
	var value := read_number()
	if not is_finite(value):
		say("İvmeyi m/s² biriminde sayı olarak gir.", BAD)
	elif absf(value - _current_g()) <= 0.15:
		_enter_repair()
	else:
		say("h = ½gt²; süreyi karesiyle ve birimiyle kullan.", BAD)
func _enter_repair() -> void:
	step = Step.REPAIR
	_calibration_index = 0
	var view := _stage()
	view.rewind()
	view.pressure = 0
	view.pressure_target = 0
	view.log_rows.clear()
	view.set_bodies([&"steel", &"foam"])
	screen(3, "Düzelt", "İki ayarı ölç; 10 m/s² sağlayan dengeleyici ayarını hesapla.", "İlk kalibrasyonu ölç", "Ayar ile g doğrusal değişir. İki ölçümden artış oranını ve başlangıç değerini bul.")
	add_entry("Dengeleyici ayarı")
	entry.editable = false
func _run_repair() -> void:
	if _calibration_index < 2:
		dial = 0.0 if _calibration_index == 0 else BROKEN_DIAL
	else:
		var value := read_number()
		if not is_finite(value) or value < 0 or value > 100:
			say("Ayarı 0 ile 100 arasında sayı olarak gir.", BAD)
			return
		dial = value
	_stage().gravity = _current_g()
	_launch()
func _on_repair_landed(results: Dictionary) -> void:
	_run_pending = false
	var time: float = results[&"steel"].time
	var measured := 2 * TEST_HEIGHT / (time * time)
	_stage().gravity_label = ("%.1f m/s²" % measured).replace(".", ",")
	_stage().log_rows.append(("ayar %.0f: g = %.1f m/s²" % [dial, measured]).replace(".", ","))
	if _calibration_index < 2:
		_calibration_index += 1
		entry.editable = _calibration_index == 2
		hud.set_action("İkinci kalibrasyonu ölç" if _calibration_index == 1 else "Ayarı uygula", true)
	elif absf(_current_g() - HEALTHY_G) <= 0.02:
		_stage().gravity_fixed = true
		_stage().show_expectation = false
		_enter_rescue()
	else:
		say("Girilen ayarın ölçümü kayıtta; iki noktadan tekrar hesapla.", BAD)
		hud.set_action("Ayarı uygula", true)
func _enter_rescue() -> void:
	step = Step.RESCUE
	var view := _stage()
	view.rewind()
	view.door_enabled = true
	view.door_time = TARGET_TIME
	view.time_scale = 1.0
	view.capsules = 3
	view.outcome = &""
	view.log_rows.clear()
	view.set_bodies([&"capsule"])
	screen(4, "Toparla", "Onarılan çekimde kapsülü cihazdaki yeni kapak süresine yetiştir.", "Ayarla ve bırak", "Kapsül ilk hızsız bırakılır. Kapak süresini cihazdan oku; yüksekliği kendin hesapla. Üç kapsülün var.")
	add_power("Sar", "Aynı koşul tekrar oynar; kaybedilen hak geri gelmez", _replay_drop)
	add_entry("Yükseklik (m)")
func _run_rescue() -> void:
	if _out_of_tries:
		_enter_crisis()
		return
	var value := read_number()
	if not is_finite(value) or value < 1 or value > Stage.MAX_RELEASE:
		say("Yüksekliği odanın 1 ile 58 m aralığında sayı olarak gir.", BAD)
		return
	_stage().set_release_height(value)
	_launch()
func _launch() -> void:
	_run_pending = true
	_stage().rewind()
	hud.set_action("Ölçülüyor", false)
	_stage().release(_stage().visible_ids)
func _replay_drop() -> void:
	if _run_pending:
		_stage().rewind()
		_stage().release(_stage().visible_ids)
func _on_action() -> void:
	if _run_pending or _sealed: return
	match step:
		Step.CRISIS: _enter_test()
		Step.TEST:
			if _vacuum_equal and _air_seen:
				_enter_reason()
			elif _stage().is_pumping():
				say("Basıncın sabitlenmesini bekle.")
			else:
				_drop_pressure = _stage().pressure
				_air_control.editable = false
				_launch()
		Step.REASON:
			if evidence_verified: _enter_measure()
		Step.MEASURE: _check_measure()
		Step.REPAIR: _run_repair()
		Step.RESCUE: _run_rescue()
func _on_landed(results: Dictionary) -> void:
	match step:
		Step.CRISIS:
			hud.set_action("Nedenini bul", true)
			say("Kapsül kapak kapandıktan sonra indi; veri kayboldu.", BAD)
		Step.TEST: _on_test_landed(results)
		Step.REPAIR: _on_repair_landed(results)
		Step.RESCUE:
			_run_pending = false
			if _stage().outcome == &"saved":
				step = Step.DONE
				seal("Çekim ayarı ölçümle onarıldı; kapsül yeni sürede kurtarıldı.", "Düzen onarıldı; kapsül zamanında ulaştı.")
			elif _stage().capsules == 0:
				_out_of_tries = true
				clear_tools()
				hud.set_action("Krize sar", true)
				say("Kapsüller tükendi; krizi yeniden ölç.", BAD)
			else:
				say("Kapak ile varış çizgilerini karşılaştır; yükseklik hatalı.", BAD)
				hud.set_action("Ayarla ve bırak", true)
