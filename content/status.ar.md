---
title: "الحالة"
linkTitle: "الحالة"
description: "فحوص تلقائية للتأكد من أن التطبيق العامل هو الشيفرة المنشورة بالضبط: كل ساعة، وكل يوم مع إعادة البناء من المصدر."
---

{{< status >}}

## كيف تعمل هذه الفحوص

تشغّل [مهمة مجدولة](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) في المستودع العام لهذا الموقع النصَّ [`verify-site.sh`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-site.sh)، من مستودع شيفرة التطبيق، على التطبيق العامل. كل السجلات عامة: افتح أيًّا منها لترى كل فحص وكل ملف. لتشغيل الفحوص نفسها بنفسك، انظر [التحقق من التطبيق](/ar/verify/).
