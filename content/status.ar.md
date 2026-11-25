---
title: "الحالة"
linkTitle: "الحالة"
description: "فحوص تلقائية للتأكد من أن التطبيق الذي يعمل حاليًا هو الشيفرة المنشورة بالضبط، كل ساعة وكل يوم مع إعادة البناء من المصدر، ومن أن البوت يفتح هذا التطبيق."
---

{{< status >}}

## كيف تعمل هذه الفحوص

تشغّل [مهمة مجدولة](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) في المستودع العام لهذا الموقع النصَّ البرمجي [`verify-site.sh`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-site.sh)، من مستودع شيفرة التطبيق، على التطبيق الذي يعمل حاليًا. كل السجلات عامة: افتح أيًّا منها لترى كل فحص وكل ملف. لتشغيل الفحوص نفسها بنفسك، انظر [التحقق من التطبيق](/ar/verify/).

وتشغّل [مهمة مجدولة أخرى](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-bot.yml) النصَّ البرمجي [`verify-bot.py`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-bot.py)، من مستودع شيفرة التطبيق أيضًا، كل ساعة بحساب تيليجرام أُنشئ لهذا الغرض. يسأل تيليجرام عمّا تفتحه روابط التطبيق (`t.me/{{< param "botUsername" >}}?startapp`) وزر القائمة في البوت، ويرسل إلى البوت `/start` ليقرأ الزر في ردّه، وكل ذلك دون فتح التطبيق. يُظهر هذا ما قُدِّم لذلك الحساب في تلك اللحظة: إن استُبدل التطبيق لأشخاص مختارين فقط، أو لمدة قصيرة بين فحصين، فلن يظهر ذلك هنا. لتتحقق مما يُقدَّم لك أنت، شغّل النص البرمجي نفسه بحسابك الخاص ([الطريقة، بالإنجليزية](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/verifying.md#checking-what-the-bot-opens)).
