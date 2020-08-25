********
Yetkiler
********

Hyperledger Iroha kullanıcılarının eylemlerini sınırlamak için rol-bazlı bir erişim kontrol sistemi kullanır .
Bu sistem farklı erişim seviyelerine sahip kullanıcı gruplarını içeren kullanım durumlarını uygulamaya büyük ölçüde yardımcı olur —
varlık transferi bile alamayan zayıf kullanıcılardan süper-kullanıcılara kadar.
Yetkilendirme sistemimizin güzelliği bir süper-kullanıcıya sahip olmak zorunda olmamanızdır.
Iroha kurulumunuzda veya muhtemel bütün yetkileri kullandığınızda: ayrılmış ve hafif roller yaratabilirsiniz. 

Sistemin bakımı rollerde bulunan rolleri ayarlamayı ve yetkileri içerir.
Sistem yayılmasının ilk adımında bu yapılabilir — genesis blokta,
veya sonra Iroha ağı hazır ve çalışıyorken, roller değiştirilebilir (eğer bunu yapabilecek bir rol varsa :)

Bu bölüm yetkileri anlamak için ve belirli yetkileri içeren rolleri nasıl yaratacağına dair fikir vermesi için size yardımcı olacaktır.
Her yetki Python'da yazılmış işlem veya sorgu yaratmanın yolunun gösteren bir örnekle sağlanır,
spesifik yetki gerektirir. Her örnek listelemesi `Supplementary Sources`_ bölümünde bulunan *commons.py* modülünü kullanır.

******************
Yetkilerin Listesi
******************

.. iroha_gen_permissions_index:: permissions/matrix.csv

*****************
Ayrıntılı İzinler
*****************

.. iroha_gen_detailed_permissions:: permissions/matrix.csv
