# MERİDYEN onarım akışı

Doğrulanan çalışma: `codex/meridian-repair` dalı, `glitch-academy-meridian/` çalışma kopyası. Başlangıç kopyasındaki ortak dosyalar çalışma sırasında dışarıdan değiştiği için son entegrasyon bu kopyada tamamlandı. Ana klasördeki eşzamanlı tasarım çalışması bu dalın test sonucu değildir.

## Değişiklikler

- Newton, Atış ve Çarpışma artık görev sözleşmesini uygular. İki kontrollü ölçüm gerçek sonuçtan kaydedilir; oyuncu kanıtı ayara taşır, doğru modeli kendisi yazar ve iki farklı yeni kargoyu kurtarır. Tekrarlanan aynı kanıt ilerletmez. Üç ortak hak tükenince kanıtlar ve onarım sıfırlanır. Serbest laboratuvarlar `lab.tscn` altında korunur. Sınıflar keşfine bağlandı; sınav rotası sırası değiştirilmedi.
- Düşüşte vakum ve hava kayıtları zorunludur. g hesaplandıktan sonra iki noktalı kalibrasyon yapılır. Kaydırıcıyla cevap aramak kaldırıldı. Önce dünya onarılır, sonra yeni kapak süresinde kapsül kurtarılır. Eski 27 m cevabı geçmez. Basınç koşu boyunca sabittir; yeniden oynatmada eski sonuç olayı iptal edilir.
- Dalga ve Fotoelektrik'te üç cevap düğmesi yerine ölçüm fişleri ve ayar satırları kullanılır. Enter kanıt adımını atlayamaz. Hazır cevap içeren örnekler ve sınırsız hak yenileme kaldırıldı. Dalga düzeltme ölçümü toparlamanın cevabını söylemez. Fotoelektrik koşusunda tekrar Enter ek hak harcatmaz.
- LGS ortak sahnesinde düzenek büyütüldü; açıklamalar ve seçenekler aynı sağ sütuna alındı. Kanıt sürüklemeye klavye karşılığı eklendi; İngilizce kayda eksik olumsuz mesaj eklendi. Köprü eşdeğer `ab+ab` açılımını kabul eder. Tükenen hak, görünür krize yeniden başlamayı gerektirir; mühür yalnız başarıdan sonra bir kez çıkar.
- Yönerge ve bildirimler satıra sarılır; bildirimler araçların üzerinde kalır. Dalga yüzeyi düşük kontrastlı tek su tonuna ve en çok 0,8 Hz görsel hıza alındı; fizik hesap frekansı korunur. Kontrol merkezindeki yeniden ebeveynleme sonrası düğüm erişimi düzeltildi.

## Kontrol

Godot 4.7.2 ile geçti:

```sh
Godot --headless --path . --script tests/repair_bench_flow_test.gd
Godot --headless --path . tests/free_fall_flow_test.tscn
Godot --headless --path . tests/physics_flow_test.tscn
Godot --headless --path . --script tests/physics_rules_test.gd
Godot --headless --path . --script tests/lgs_campaign_flow_test.gd
Godot --headless --path . --script tests/lgs_repair_logic_test.gd
Godot --headless --path . --quit-after 80
```

Doğru ve hatalı giriş, eksik/tekrar kanıt, erken mühür, Enter tekrarı, iki bağımsız uygulama, hakların tükenmesi, krize dönüş ve rota kilitleri denendi. Sayısal uygulama cevapları testte bağımsız sabitlerle doğrulanır. Test kayıtlarında başarısız kontrol ve çalışma zamanı script hatası yok. Bazı 3D sahneleri kapatırken Godot kaynak/RID temizliği uyarıları veriyor; bellek kullanımının uzun oturum testi bu değişikliğin kapsamına alınmadı.

`tests/meridian_capture.gd` ile 1280×720 gerçek Godot görüntüleri alındı. `-- 130` arayüz Control metinlerini %130 büyüterek, `-- 130 detail` kanıt görünümünü açarak tekrar üretir. Canvas/3D üzerine çizilen eski ölçüm metinleri bu büyütme aracından bağımsızdır; Düşüş ve Dalga'da okunurluk için en az 16 px uygulanır. Görseller `meridian-repair/` altında.

Bu çalışma diğer biyoloji, mikro YKS görevleri, tarih ve mevsim istasyonlarının bütün deney mantığını yeniden yazmaz. İnsanla ilk 10 saniye anlaşılabilirlik testi yapılmadı; otomatik akış ve görsel inceleme bunun yerine sayılmadı.
