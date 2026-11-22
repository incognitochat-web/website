---
title: "İstatistikler"
linkTitle: "İstatistikler"
description: "Hizmetin ay ay ne kadar kullanıldığı ve çalıştırılmasının ne kadara mal olduğu. Gerçek sayılar."
---

{{< stats >}}

## Neler sayılıyor

- **Kurulan hesaplar**: başarılı kurulumlar; yeni bir cihazda yeniden kurulum ve yanıtı kaybolduğu için yeniden denenen bir kurulum da dahil.
- **Gönderilen mesajlar**: insanların yazdığı, metin, ek ya da çıkartma içeren mesajlar. Uygulamanın “sessiz” olarak işaretlediği görüldü bilgileri, tepkiler, düzenlemeler, silmeler ve anahtar güncellemeleri sayılmaz. Artık çalışmayan bir bağlantıya yapılan gönderimler de sayılır, çünkü sunucu bunlara bilerek aynı şekilde yanıt verir. Değiştirilmiş bir uygulama bir mesajı “sessiz” olarak işaretleyebilir ya da, jetonlarının yettiği ölçüde, daha fazlasını gönderebilir.
- **Medya**: ödemesi yapılan eklerin boyutu, uygulamanın her dosyaya eklediği dolgu dahil (1 MiB'a kadar ikinin bir kuvvetine, sonrasında tam MiB'a), yani gerçek boyutlarından biraz fazla. Tamamlanan yüklemeleri değil, ödemesi yapılan yüklemeleri sayar ve her tür dosyayı birlikte sayar: sunucu bir fotoğrafı sesli mesajdan ayırt edemez.
- **Maliyetler**: hizmetin her gün çalıştırılması için AWS tarafından alınan ücret, olası krediler düşülmeden: canlı ortam hizmete göre (en büyük dördü adıyla), test ortamı tek bir toplam olarak. AWS son günlerin tutarlarını bir süre daha düzeltir ve bu ayın sayıları onun tahminleridir.

Yalnızca sayılar ve toplamlar: burada da, sayıların geldiği yerde de kimin ne yaptığını söyleyen hiçbir şey yok.

## Sayılar nereden geliyor

- Uygulamanın sunucusu dakikada bir sayar ve AWS (CloudWatch) bu sayıları saat saat toplar. Bu sitenin herkese açık deposundaki [zamanlanmış bir iş](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/stats.yml), yalnızca metrikleri ve maliyetleri okuyabilen bir rolle, sayıları her saat, maliyetleri ise günde bir kez okur.
- Bir saatin sayıları, sunucunun onları yazdığı zamana göre tarihlenir; trafiği az olan bir sunucuda bu çok daha sonra olabilir: sunucu bir dakikanın sayılarını bir sonraki istekle ya da kapanırken yazar. Bu yüzden bir saat, daha önceki saatlerin sayılarını da içerebilir. Her çalıştırma son 7 günü yeniden okur; böylece bir haftaya kadar geciken ya da kaçırılan çalıştırmalar boşluk bırakmaz.
- İş, okuduğu her sayıyı deponun [`data` dalında](https://github.com/{{< param "siteRepo" >}}/tree/data/stats) saklar, böylece geçmişleri herkese açıktır; yazdığı her dosyayı da Sigstore ile imzalar:

  ```shell
  gh attestation verify <file> --repo {{< param "siteRepo" >}} \
    --cert-identity https://github.com/{{< param "siteRepo" >}}/.github/workflows/stats.yml@refs/heads/main
  ```

- Bu, bir sayının bu herkese açık işten değiştirilmeden geçtiğini gösterir. AWS hesabındaki verilerin doğru olduğunu ise gösteremez: AWS hesabını yöneten kişi onları değiştirebilir. Sunucu doğrulanabilir bir güvenli bölgede çalışmaya başladığında ([ana sayfadaki](/tr/) yol haritasına bakın), sayıları kendisi sayıp imzalayacak.
