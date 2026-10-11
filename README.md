# Lumi Planner

Akıllı dijital ajanda: ana sayfa, takvim, notlar, mail. Flutter, Android öncelikli.

## Durum (Aşama 1–2)

| Özellik | Durum |
|---|---|
| Tema, renk sistemi, tipografi (gömülü yazı tipleri) | Yazıldı |
| 5 sekmeli alt gezinme (durum korunur) | Yazıldı |
| Ana Sayfa: selamlama, hafta şeridi, görevler, haftalık ilerleme, günün notu, hızlı erişim | Yazıldı |
| Görev ekleme / tamamlama / kaydırarak silme (geri al ile) | Yazıldı, **yalnızca bellekte** (uygulama kapanınca silinir; Aşama 3'te kalıcı olacak) |
| Takvim, Notlar, Mail, Daha Fazla | Yer tutucu; henüz çalışmıyor |
| Toplantı/Not/Fotoğraf ekle, arama, bildirim | Henüz çalışmıyor (bilgi mesajı gösterir) |

Bu kod yazıldığı ortamda **derlenmedi ve çalıştırılmadı**. İlk doğrulama GitHub Actions'ta yapılır.

## APK üretme (bilgisayara kurulum gerektirmez)

1. GitHub'da yeni bir **özel (private)** depo açın.
2. Bu klasörün içeriğini depoya yükleyin (`.github` klasörü dahil).
3. Depoda **Actions** sekmesine gidin, "Analiz, test ve APK" iş akışının bitmesini bekleyin.
4. Bitince çalışmanın sayfasında **Artifacts → lumi-planner-release-apk** dosyasını indirin.
5. Zip'ten çıkan `app-release.apk` dosyasını telefona aktarıp kurun ("bilinmeyen kaynaklardan kurulum" iznini vermeniz gerekir).

Not: Bu APK Flutter'ın varsayılan **debug anahtarıyla** imzalanır; kişisel test içindir, Play Store'a yüklenemez. Gerçek imzalama Aşama 10'da hazırlanacak.

## Yerelde çalıştırma (isteğe bağlı)

```
flutter create --platforms=android --org app.lumi --project-name lumi_planner .
flutter pub get
flutter run
```

## Bilinen sınırlar

- Manzara, tavşan ve botanik illüstrasyonlar yok; gökyüzü başlığı koddan çizilen basit bir yaklaşım. Gerçek PNG/SVG dosyaları eklenince `lib/features/home/sky_header.dart` değiştirilebilir.
- Yazı tipleri değişken (variable) font dosyalarıdır; kalın/yarı kalın ağırlıkların cihazda doğru görünmesi derleme sonrası kontrol edilmelidir.
- Uygulama adı `lib/core/config/app_config.dart` içinden değiştirilir (Android'deki görünen ad için ayrıca `AndroidManifest.xml` güncellenmelidir).
