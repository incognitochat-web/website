---
title: "Durum"
linkTitle: "Durum"
description: "Canlı uygulamanın tam olarak yayımlanan kod olduğuna (her saat, ayrıca her gün kaynaktan yeniden derlenerek) ve botun bu uygulamayı açtığına dair otomatik kontroller."
---

{{< status >}}

## Bu kontroller nasıl çalışır

Bu sitenin herkese açık deposundaki [zamanlanmış bir iş](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml), uygulamanın kod deposundaki [`verify-site.sh`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-site.sh) betiğini canlı uygulamaya karşı çalıştırır. Her kayıt herkese açıktır: her kontrolü ve her dosyayı görmek için birini açın. Aynı kontrolleri kendiniz çalıştırmak için [Uygulamayı doğrulayın](/tr/verify/) sayfasına bakın.

[Zamanlanmış başka bir iş](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-bot.yml) de, yine uygulamanın kod deposundaki [`verify-bot.py`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-bot.py) betiğini, bu amaçla oluşturulmuş bir Telegram hesabıyla her saat çalıştırır. Betik, uygulamanın bağlantılarının (`t.me/{{< param "botUsername" >}}?startapp`) ve botun menü düğmesinin neyi açtığını Telegram'a sorar ve botun yanıtındaki düğmeyi okumak için bota /start gönderir; bunların hepsini uygulamayı açmadan yapar. Bu, o hesaba o anda ne sunulduğunu gösterir: uygulama yalnızca seçilen kişiler için ya da iki kontrol arasında kısa bir süreliğine başka bir şeyle değiştirilirse, bu burada görünmez. Size ne sunulduğunu kontrol etmek için aynı betiği kendi hesabınızla çalıştırın ([nasıl yapılır, İngilizce](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/verifying.md#checking-what-the-bot-opens)).
