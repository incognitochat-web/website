---
title: "Durum"
linkTitle: "Durum"
description: "Canlı uygulamanın tam olarak yayımlanan kod olduğuna (her saat, ayrıca her gün kaynaktan yeniden derlenerek) ve botun bu uygulamayı açtığına dair otomatik kontroller."
---

{{< status >}}

## Bu kontroller nasıl çalışır

Bu sitenin herkese açık deposundaki iki zamanlanmış iş, [Uygulamayı doğrulayın](/tr/verify/) sayfasındaki kontrolleri çalıştırır; bu kontrolleri o sayfadan kendiniz de çalıştırabilirsiniz. [`check-app.yml`](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) canlı uygulamayı her saat kontrol eder ve günde bir kez onu kaynaktan yeniden de derler; [`check-bot.yml`](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-bot.yml) botun neyi açtığını, bu amaçla oluşturulmuş bir Telegram hesabıyla her saat kontrol eder. Her çalıştırmanın kaydı herkese açıktır. Bot kontrolü yalnızca o hesaba o anda gösterileni yansıtır: size ne gösterildiğini kontrol etmek için [kendi hesabınızla çalıştırın](/tr/verify/#bot-check).
