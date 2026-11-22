---
title: "Durum"
linkTitle: "Durum"
description: "Canlı uygulamanın tam olarak yayımlanan kod olduğuna dair otomatik kontroller: her saat, ayrıca her gün kaynaktan yeniden derlenerek."
---

{{< status >}}

## Bu kontroller nasıl çalışır

Bu sitenin herkese açık deposundaki [zamanlanmış bir iş](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml), uygulamanın kod deposundaki [`verify-site.sh`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-site.sh) betiğini canlı uygulamaya karşı çalıştırır. Her kayıt herkese açıktır: her kontrolü ve her dosyayı görmek için birini açın. Aynı kontrolleri kendiniz çalıştırmak için [Uygulamayı doğrulayın](/tr/verify/) sayfasına bakın.
