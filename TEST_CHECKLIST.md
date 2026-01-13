# 📱 Trendyol Clone - Test Checklist

**Test Tarihi:** _______________  
**Test Cihazı:** _______________  
**iOS Versiyonu:** _______________

---

## 🔴 KRİTİK TESTLER (Mutlaka Yapılmalı)

### 1. Network Durumları Testi

#### ✅ Online → Offline Geçişi
- [ ] Uygulamayı aç, ürünleri görüntüle
- [ ] **WiFi/Mobil veriyi kapat**
- [ ] Sepete ürün eklemeyi dene
  - **Beklenen:** "İnternet bağlantınız yok" uyarısı gösterilmeli
  - **Beklenen:** Ürün sepete EKLENMEMELİ
- [ ] Favorilere eklemeyi dene
  - **Beklenen:** Çalışmalı (offline da çalışır)
- [ ] Sepeti görüntüle
  - **Beklenen:** Önceden eklenen ürünler görünmeli (cache'den)

#### ✅ Offline → Online Geçişi
- [ ] Uygulama offline iken açık
- [ ] **WiFi/Mobil veriyi aç**
- [ ] Pull-to-refresh yap (Discovery, Favorites, Cart)
  - **Beklenen:** Veriler güncellenmeli
  - **Beklenen:** Loading indicator görünmeli

#### ✅ Yavaş Network
- [ ] Network throttling aç (Settings → Developer → Network Link Conditioner)
- [ ] Ürünleri yükle
  - **Beklenen:** 30 saniye timeout sonrası hata vermeli
  - **Beklenen:** Retry mekanizması çalışmalı (3 kez denemeli)

---

### 2. Image Loading Testi

#### ✅ Placeholder Kontrolü
- [ ] Ürün listesini aç
- [ ] **Resimler yüklenirken:**
  - **Beklenen:** Placeholder (photo icon) görünmeli
  - **Beklenen:** Boş görünmemeli
- [ ] **Resim yüklendiğinde:**
  - **Beklenen:** Gerçek resim görünmeli
  - **Beklenen:** Smooth transition olmalı

#### ✅ Image Error Handling
- [ ] Geçersiz URL'li bir ürün ekle (manuel test için)
- [ ] **Beklenen:** Fallback placeholder (photo.artframe) görünmeli
- [ ] **Beklenen:** Uygulama çökmemeli

#### ✅ Image Cache
- [ ] Ürün listesini aç, resimleri yükle
- [ ] Uygulamayı kapat
- [ ] Uygulamayı tekrar aç
- [ ] **Beklenen:** Resimler anında görünmeli (cache'den)

---

### 3. Cache Mekanizması Testi

#### ✅ Cache TTL (Time To Live)
- [ ] Ürünleri yükle
- [ ] Uygulamayı kapat
- [ ] **1 saat bekle** (veya cache TTL'ini kısalt)
- [ ] Uygulamayı aç
- [ ] **Beklenen:** Cache expire olmuşsa network'ten yeni veri çekmeli

#### ✅ Offline Cache
- [ ] Ürünleri yükle (online)
- [ ] İnterneti kapat
- [ ] Uygulamayı kapat
- [ ] Uygulamayı aç (offline)
- [ ] **Beklenen:** Önceki veriler görünmeli (cache'den)

---

### 4. Memory Management Testi

#### ✅ Memory Warning
- [ ] Uygulamayı aç
- [ ] Birçok ürün görüntüle (scroll yap)
- [ ] **Simulator'da:** Device → Simulate Memory Warning
- [ ] **Gerçek cihazda:** Başka uygulamalar aç (memory pressure oluştur)
- [ ] **Beklenen:** Uygulama çökmemeli
- [ ] **Beklenen:** Image cache temizlenmeli

#### ✅ Task Cancellation
- [ ] Ürün listesini aç (loading başlasın)
- [ ] Hemen başka ekrana geç
- [ ] **Beklenen:** Önceki task iptal edilmeli
- [ ] **Beklenen:** Memory leak olmamalı

---

### 5. Error Handling & Recovery Testi

#### ✅ Network Error Recovery
- [ ] İnterneti kapat
- [ ] Ürün listesini aç
- [ ] **Beklenen:** Error view görünmeli
- [ ] **Beklenen:** "Tekrar Dene" butonu olmalı
- [ ] "Tekrar Dene" butonuna bas
- [ ] **Beklenen:** Loading başlamalı
- [ ] İnterneti aç
- [ ] **Beklenen:** Veriler yüklenmeli

#### ✅ Retry Mechanism
- [ ] Network throttling aç (çok yavaş)
- [ ] Ürünleri yükle
- [ ] **Beklenen:** 3 kez retry yapmalı (1s, 2s, 4s delay ile)
- [ ] **Beklenen:** Her retry'da exponential backoff olmalı

---

## 🟡 ÖNEMLİ TESTLER

### 6. VIPER Modülleri Testi

#### ✅ Discovery (Ana Sayfa)
- [ ] Ürünler yükleniyor mu?
- [ ] Kategoriler görünüyor mu?
- [ ] Kategori seçince filtreleme çalışıyor mu?
- [ ] Arama çalışıyor mu?
- [ ] Ürün detayına gidiliyor mu?
- [ ] Pull-to-refresh çalışıyor mu?
- [ ] Banner ve Feature section'lar görünüyor mu?

#### ✅ Favorites
- [ ] Favorilere ekleme çalışıyor mu?
- [ ] Favorilerden çıkarma çalışıyor mu?
- [ ] Favoriler listesi doğru mu?
- [ ] Boş state görünüyor mu?
- [ ] Pull-to-refresh çalışıyor mu?

#### ✅ Cart
- [ ] Sepete ekleme çalışıyor mu?
- [ ] Miktar artırma/azaltma çalışıyor mu?
- [ ] Ürün silme çalışıyor mu?
- [ ] Toplam fiyat doğru mu?
- [ ] Tab bar badge güncelleniyor mu?
- [ ] Boş state görünüyor mu?
- [ ] Pull-to-refresh çalışıyor mu?

#### ✅ Product Detail
- [ ] Ürün detayları görünüyor mu?
- [ ] Favorilere ekleme/çıkarma çalışıyor mu?
- [ ] Sepete ekleme çalışıyor mu?
- [ ] Offline'da sepete ekleme engelleniyor mu?

#### ✅ Account
- [ ] Kullanıcı bilgileri görünüyor mu?
- [ ] Menü öğeleri görünüyor mu?
- [ ] Dark mode sorunu var mı? (Her zaman light mode olmalı)

---

### 7. UI/UX Testi

#### ✅ Loading States
- [ ] Her ekranda loading indicator görünüyor mu?
- [ ] Loading sırasında UI donuyor mu? (Donmamalı)
- [ ] Loading bittiğinde indicator kayboluyor mu?

#### ✅ Empty States
- [ ] Favoriler boşken empty state görünüyor mu?
- [ ] Sepet boşken empty state görünüyor mu?

#### ✅ Pull-to-Refresh
- [ ] Discovery'de pull-to-refresh çalışıyor mu?
- [ ] Favorites'te pull-to-refresh çalışıyor mu?
- [ ] Cart'ta pull-to-refresh çalışıyor mu?

#### ✅ Navigation
- [ ] Tab bar navigation çalışıyor mu?
- [ ] Back button çalışıyor mu?
- [ ] Ürün detayına gidiliyor mu?

---

### 8. Thread Safety Testi

#### ✅ Concurrent Operations
- [ ] Hızlıca birçok ürünü favorilere ekle
- [ ] Hızlıca birçok ürünü sepete ekle
- [ ] **Beklenen:** Data race olmamalı
- [ ] **Beklenen:** Tüm işlemler doğru kaydedilmeli

#### ✅ UI Thread Safety
- [ ] Network isteği sırasında UI güncellemeleri
- [ ] **Beklenen:** Tüm UI güncellemeleri main thread'de olmalı
- [ ] **Beklenen:** Crash olmamalı

---

### 9. Accessibility Testi

#### ✅ VoiceOver
- [ ] Settings → Accessibility → VoiceOver → Aç
- [ ] Uygulamayı kullan
- [ ] **Beklenen:** Tüm butonlar okunabilir olmalı
- [ ] **Beklenen:** accessibilityLabel ve accessibilityHint çalışmalı

---

## 🟢 NİCE TO HAVE TESTLER

### 10. Performance Testi

#### ✅ Scroll Performance
- [ ] Ürün listesinde hızlı scroll yap
- [ ] **Beklenen:** Smooth scrolling olmalı
- [ ] **Beklenen:** Frame drop olmamalı (60 FPS)

#### ✅ Image Loading Performance
- [ ] Birçok ürün görüntüle
- [ ] **Beklenen:** Resimler lazy load olmalı
- [ ] **Beklenen:** Memory kullanımı makul olmalı

---

### 11. Edge Cases

#### ✅ Empty Response
- [ ] API boş array döndürürse ne olur?
- [ ] **Beklenen:** Empty state görünmeli

#### ✅ Invalid Data
- [ ] Geçersiz JSON gelirse ne olur?
- [ ] **Beklenen:** Error mesajı gösterilmeli
- [ ] **Beklenen:** Uygulama çökmemeli

#### ✅ Very Long Text
- [ ] Çok uzun ürün başlığı olan bir ürün
- [ ] **Beklenen:** UI bozulmamalı
- [ ] **Beklenen:** Text truncate olmalı

---

## 📊 TEST SONUÇLARI

### Başarılı Testler ✅
- 

### Başarısız Testler ❌
- 

### Bulunan Bug'lar 🐛
1. 
2. 
3. 

### Öneriler 💡
- 

---

## 🔍 ÖZEL DİKKAT EDİLMESİ GEREKENLER

### ⚠️ Mutlaka Kontrol Et:
1. **Offline sepete ekleme:** İnternet yokken sepete ekleme engellenmeli
2. **Memory warning:** Uygulama çökmemeli
3. **Image placeholder:** Resim yüklenirken boş görünmemeli
4. **Error recovery:** "Tekrar Dene" butonu çalışmalı
5. **Cache TTL:** 1 saat sonra cache expire olmalı
6. **Thread safety:** Concurrent işlemlerde data race olmamalı

### 🎯 Test Senaryoları:
1. **Normal kullanım:** Online, hızlı network
2. **Yavaş network:** Network throttling ile
3. **Offline:** İnternet kapalı
4. **Memory pressure:** Çok fazla uygulama açık
5. **Rapid actions:** Hızlıca birçok işlem yap

---

## 📝 NOTLAR

- Test sırasında Xcode Console'u açık tut (Logger mesajlarını görmek için)
- Network Link Conditioner kullan (yavaş network simülasyonu için)
- Memory warning simulator'da test edilebilir
- VoiceOver gerçek cihazda test edilmeli

---

**Test Sonucu:** ⬜ Başarılı  ⬜ Başarısız (Bug'lar var)

**Test Eden:** _______________

**Tarih:** _______________

