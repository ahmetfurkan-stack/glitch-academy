# Newton Kızağı

`mission.tscn` artık onarım görevidir: iki kontrollü ölçüm, kanıt fişleri, yazılan ivme kuralı ve iki bağımsız kargo uygulaması. Kargolar bitince ölçüm baştan yapılır. Kontrol merkezinde Sınıflar / 11. sınıf / Fizik altındadır; sınav sırası değiştirilmez.

Önceki serbest laboratuvar `lab.tscn` altında korunur. Fizik `newton_sim.gd`, ortak onarım akışı `scripts/physics/repair_bench.gd` içindedir.

Kontrol: `Godot --headless --path . --script tests/repair_bench_flow_test.gd`.
