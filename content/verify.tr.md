---
title: "Uygulamayı doğrulayın"
linkTitle: "Doğrulama"
description: "Telegram'ın açtığı uygulamanın tam olarak yayımlanan kod olduğunu herkes nasıl kontrol edebilir."
updated: "2026-11-21"
---

Şifreleme sizi ancak çalıştırdığınız uygulama yayımlanan kodun ta kendisiyse korur. Telegram içinde, botu işleten kişinin onu başka bir sayfaya yönlendirmesini hiçbir şey engellemez; bu yüzden uygulama, herkesin kontrol edebileceği bir şekilde yayımlanır.

## Uygulama nasıl yayımlanır

- **Herkesin gözü önünde derlenir.** [`{{< param "hostingRepo" >}}`](https://github.com/{{< param "hostingRepo" >}}) deposundaki herkese açık bir iş akışı, [kodun](https://github.com/{{< param "codeRepo" >}}) tek bir sürümünü derler; o depoda başka hiçbir kod yoktur.
- **Yeniden üretilebilir.** Aynı sürüm her zaman bayt bayt aynı dosyalara derlenir; böylece herkes onu yeniden derleyip karşılaştırabilir.
- **Herkese açık bir kayıtta imzalı.** O iş akışı, [Sigstore](https://www.sigstore.dev/) ile her dosyayı tek tek ve ayrıca hepsinin SHA-256 değerlerini listeleyen bir `manifest.json` dosyasını imzalar. İmzalar, sessizce yeniden yazılamayan herkese açık bir şeffaflık kaydında durur.
- **Tek adres, üzerinde başka hiçbir şey yok.** Uygulama yalnızca `{{< param "appOrigin" >}}` adresinden sunulur ve orada asla başka bir şey sunulmaz: aynı adresteki bir sayfa cihazınızdaki anahtarlara ulaşabilirdi.
- **Dışarıya kapalı.** Uygulama üçüncü taraf kodu ya da analiz aracı yüklemez; sunucudan da kod veya ayar yüklemez.

## Kendiniz kontrol edin

[Kodun](https://github.com/{{< param "codeRepo" >}}) yerel bir kopyasında, GitHub CLI ile oturum açmışken:

```shell
scripts/verify-site.sh {{< param "appOrigin" >}} {{< param "hostingRepo" >}} --rebuild
```

Betik şunları kontrol eder: sunulan her dosya, değiştirilmemiş ve incelenmiş iş akışının `main` dalındaki bir sürümden derlediği dosyanın tam olarak aynısıdır; onu aynı iş akışı çalıştırması yayına almıştır; uygulamanın adresini başka hiçbir site paylaşmaz. `--rebuild` ile o sürümü kendisi de derler ve bayt bayt karşılaştırır. Ayrıntılar ve betiğin neyi kanıtlamadığı, [Verifying the app](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/verifying.md) belgesinde (İngilizce).

## Otomatik kontrol

Aynı betik her saat canlı uygulamaya karşı, günde bir kez de `--rebuild` ile çalışır. Sonuçlar ve her kontrolün neyi kapsadığı [Durum](/tr/status/) sayfasında.

## Bunun kanıtlayamadıkları

- **Telegram içinde tek bir kişiye ne gösterildiği.** Botun sahibi uygulamayı herkes için ya da seçtiği kişiler için başka bir adrese yönlendirebilir. Başka bir adresteki sayfada anahtarlarınızın hiçbiri yoktur; bir şey elde edebilmesi için size yeniden kurulum yaptırması gerekir. Bu da eski cihazınızdaki hesabınızı fark edeceğiniz şekilde sona erdirir ve bağlantınızı değiştirir.
- **Sunucuda ne çalıştığı.** Tasarım buna bağlı değildir: kötü niyetli bir sunucu mesajları iletmeyebilir ya da geciktirebilir ve zamanlamayı izleyebilir, ancak onları okuyamaz ya da sahtesini üretemez, çünkü uygulama her anahtarı kendisi kontrol eder. Sunucunun kodunu kanıtlamak ileride atılacak bir adım (doğrulanabilir bir güvenli bölge).
