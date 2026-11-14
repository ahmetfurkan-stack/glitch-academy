---
version: 1.0
name: Yanlış Dünya · Meridian
description: Sakin, aydınlık bir bilim gözlemevi arayüzü; merak, kanıt ve onarımı öne çıkarır.
colors:
  bg: "#F4F6F2"
  surface: "#FFFFFF"
  surface-raised: "#E9EEE8"
  surface-sunken: "#EDF1EC"
  edge: "#D8E0D8"
  edge-strong: "#BDCCC3"
  ink: "#22332F"
  ink-muted: "#66766D"
  ink-faint: "#87958C"
  accent: "#3B7867"
  accent-soft: "#E0EEE6"
  accent-deep: "#285B4D"
  warm: "#C88755"
  warm-soft: "#F6EADF"
  on-warm: "#3E2A1E"
  danger: "#B85F56"
  danger-soft: "#F5E7E3"
  focus: "#236B59"
  shadow: "#26362D"
  series-a: "#5D84A0"
  series-b: "#3B7867"
  series-sum: "#C88755"
  blood-oxy: "#B94F4A"
  blood-deoxy: "#536E9C"
typography:
  hero: { fontFamily: Space Grotesk, fontSize: 52px, fontWeight: 700, lineHeight: 1.05, letterSpacing: -1px }
  screen-title: { fontFamily: Space Grotesk, fontSize: 32px, fontWeight: 700, lineHeight: 1.15 }
  section: { fontFamily: IBM Plex Sans, fontSize: 21px, fontWeight: 600, lineHeight: 1.25 }
  button: { fontFamily: IBM Plex Sans, fontSize: 16px, fontWeight: 600, lineHeight: 1.0 }
  directive: { fontFamily: IBM Plex Sans, fontSize: 20px, fontWeight: 500, lineHeight: 1.4 }
  body: { fontFamily: IBM Plex Sans, fontSize: 16px, fontWeight: 400, lineHeight: 1.55 }
  label: { fontFamily: IBM Plex Sans, fontSize: 13px, fontWeight: 600, lineHeight: 1.3, letterSpacing: 0.4px }
  readout: { fontFamily: IBM Plex Sans, fontSize: 26px, fontWeight: 500, lineHeight: 1.0, fontFeature: tnum }
rounded: { sm: 8px, md: 12px, lg: 18px, pill: 999px }
spacing: { xxs: 4px, xs: 8px, sm: 12px, md: 16px, lg: 24px, xl: 32px, xxl: 48px, safe: 28px }
components:
  button-primary: { backgroundColor: "{colors.accent-deep}", borderColor: "{colors.accent-deep}", textColor: "#FFFFFF", typography: "{typography.button}", rounded: "{rounded.md}", height: 48px }
  button-secondary: { backgroundColor: "{colors.surface}", borderColor: "{colors.edge}", textColor: "{colors.ink}", typography: "{typography.button}", rounded: "{rounded.md}", height: 44px }
  button-quiet: { backgroundColor: transparent, textColor: "{colors.ink-muted}", typography: "{typography.label}", height: 36px }
  focus-ring: { borderColor: "{colors.focus}", width: 2px, offset: 2px }
  panel: { backgroundColor: "{colors.surface}", borderColor: "{colors.edge}", rounded: "{rounded.lg}", padding: "{spacing.lg}" }
  hud-directive: { backgroundColor: "rgba(255,255,255,0.96)", borderColor: "{colors.edge}", textColor: "{colors.ink}", typography: "{typography.directive}", rounded: "{rounded.lg}" }
  input-number: { backgroundColor: "{colors.surface}", borderColor: "{colors.edge-strong}", focusBorderColor: "{colors.focus}", typography: "{typography.readout}", rounded: "{rounded.md}", height: 48px }
---

# Yanlış Dünya · Marka ve arayüz sistemi

Bu belge önceki koyu uzay temalı `DESIGN.md` sistemini tamamen değiştirir. Yeni arayüz için geçerli tek görsel kaynaktır. Oyun döngüsü ve öğretim yaklaşımı [GAME_DESIGN.md](GAME_DESIGN.md) içinde kalır.

## Marka özü

**Marka adı:** Yanlış Dünya
**Ürün imzası:** MERİDYEN Gözlemevi
**Söz:** *Ölç. Anla. Onar.*
**Kişilik:** Meraklı, sakin, güvenilir ve elini kirletmekten çekinmeyen bir bilim rehberi.

Oyuncu, yanlış çalışan bir dünyayı gözleyip kanıtla onarır. Görsel kimlik, bilim laboratuvarının düzenini ve defter sayfasının dokunsal sıcaklığını birleştirir. Koyu uzay ekranları, neon parıltılar, sert köşeli askerî HUD ve yoğun dekoratif çizgiler yeni kimliğin parçası değildir.

## Görsel kimlik

- **Zemin:** yumuşak kâğıt tonu `#F4F6F2`; saf beyazı yalnızca kart ve içerik yüzeylerinde kullan.
- **Metin:** koyu yosun `#22332F`; ikincil bilgi `#66766D`. Açık renkli metni açık yüzeye koyma.
- **Ana vurgu:** sakin adaçayı `#3B7867`; eylem düğmesinde daha koyu `#285B4D`.
- **İkincil vurgu:** ölçüm ve öneri için yumuşak bakır `#C88755`. Tehlike için kiremit `#B85F56`; ikisini durum rengi olarak karıştırma.
- **Yüzey:** kartlar beyaz, alt paneller `#E9EEE8`; ince kenar `#D8E0D8`, belirgin odak `#236B59`.
- **Işık:** arayüz aydınlık ve mat. Görevlerin 3D dünyası bilimsel okunurluk için kendi doğal ışığını, gölge ve materyallerini koruyabilir; karanlık arayüz paneli/HUD kullanamaz.

## İşaret ve sözcük kullanımı

Merkez işaret; kesintili yörüngenin ortasında ölçüm iğnesi gibi duran dört köşeli bir prizmadır. Anlamı: gözle, farkı bul, hizala. İşaret sade ve tek renk çalışmalı; oyun içindeki “arıza” durumunu markanın kendisine taşımamalıdır.

Yanlış Dünya adı başlıklarda tam yazılır. MERİDYEN, gözlemevinin kalibrasyon asistanının adıdır ve ürün logosundan ayrı gösterilir. Kısa ürün imzası “Ölç. Anla. Onar.” şeklindedir.

## Yazı ve biçim

Başlıklarda Space Grotesk; uzun metin, ölçüm ve kontrol etiketlerinde IBM Plex Sans kullan. Başlıkları cümle düzeninde yaz; gereksiz büyük harf ve dar teknik font kullanma. Panel köşeleri 12–18 px, kontroller 8–12 px yuvarlaktır. 8 px aralıklı ölçek kullan; kartlar arası geniş boşluk bırak.

## Ekran dili

- Kontrol merkezi: açık kâğıt yüzey, net bir selamlama, rota seçici ve tek bir odak görevi.
- Görev kartı: konu, kısa amaç, kanıt/ilerleme ve tek bir birincil eylem.
- Deney HUD’ı: doğal 3D görüntü üstünde beyaz/krem yarı saydam bilgi levhaları; siyah cam paneller yok.
- Durumlar hem renk hem metin/ikonla anlatılır. Yeşil “onarıldı”, bakır “önerilen”, kiremit “arıza”dır.
- Animasyon kısa ve işlevseldir: ölçüm çizgisi, hizalanan işaret veya açılan mühür. Arka plan süsü ve sürekli parıltı kullanma.

## Erişilebilirlik

Metin kontrastını en az WCAG AA seviyesinde tut. Durumları yalnız renkle kodlama. Odak halkası görünür olsun; tıklanabilir alanlar en az 40 px yüksekliğinde olsun. 1280×720 ve %130 sistem yazı ölçeğinde başlıklar, eylemler ve ölçüm değeri görünür kalmalıdır.

Örnek uygulama: [marka prototipi](../prototypes/brand-v1/index.html), [SVG ekran taslağı](../prototypes/brand-v1/control-center.svg), [marka özeti](BRAND_IDENTITY.md).
