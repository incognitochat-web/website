---
title: "Güvenlik"
linkTitle: "Güvenlik"
description: "Incognito Chat ile ilgili bir güvenlik açığı nasıl bildirilir."
updated: "2026-11-21"
---

Birinin mesajlarını okumanın, bir göndereni hesabıyla ilişkilendirmenin ya da uygulamanın verdiği sözleri bozan başka bir şeyin yolunu mu buldunuz? Lütfen önce bize gizli olarak bildirin.

## Nasıl bildirilir

- **Tercihimiz:** [GitHub'da gizli olarak bildirin](https://github.com/{{< param "codeRepo" >}}/security/advisories/new). Bunu yalnızca projenin geliştiricileri görür.
- **Ya da e-postayla:** [{{< param "securityEmail" >}}](mailto:{{< param "securityEmail" >}}).

Ne bulduğunuzu, nasıl yeniden üretilebileceğini ve bir saldırganın bununla neler yapabileceğini anlatın.

## Sizi neler bekliyor

- Bir hafta içinde yanıt veririz ve bu konuda ne yapacağımızı söyleriz.
- Ciddi sorunları önce düzeltiriz; kullanıcılar güvende olduğunda neyin yanlış olduğunu ve nasıl düzeltildiğini yayımlarız.
- İsterseniz katkınızı adınızla belirtiriz.

## Lütfen

- Kendi hesaplarınızda ya da kendi çalıştırdığınız bir kopyada test edin. Bir kopya çalıştırmak için gereken her şey [kodda](https://github.com/{{< param "codeRepo" >}}) var.
- Başkalarının verilerine erişmeyin ve hizmeti başkaları için aksatmayın.
- Yayımlamadan önce, düzeltmemiz için bize makul bir süre tanıyın.

Bu şekilde yapılan araştırmalara karşı yasal işlem başlatmayacağız.

## Kapsam

Uygulama, sunucu, protokol, derleme ve yayımlama süreci ve bu web sitesi. Tasarımın koruyamadığını zaten kabul ettiği şeyler [güvenlik modelinde](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/security.md) (İngilizce) listelenmiştir; bu sınırları istismar etmenin yeni yollarını da duymak isteriz.

[`security.txt`](/.well-known/security.txt) dosyamızda aynı iletişim bilgileri standart bir biçimde yer alır.
