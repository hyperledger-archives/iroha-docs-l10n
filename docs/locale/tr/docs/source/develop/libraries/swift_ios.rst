iOS Swift Kütüphanesi
---------------------

Kütüphane iOS uygulamalarının işlem/sorgu göndermeyi, işlem durumlarının ve blok işlemesinin akışını içeren Iroha blokzinciri ile iletişim kurması için uygun bir arayüz sağlaması için yaratılmıştır.

Nereden edinilir
^^^^^^^^^^^^^^^^

Iroha iOS kütüphanesi CocoaPods ile mevcuttur. Yüklemek için, Podfile'ınıza basitçe alttaki satırı ekleyin:

.. code-block:: swift

    pod 'IrohaCommunication'

Ayrıca `reposundan <https://github.com/hyperledger/iroha-ios>`__ kütüphane için kaynak kodu indirebilirsiniz



Nasıl kullanılır
^^^^^^^^^^^^^^^^

Yeni Iroha kullanıcıları için `iOS örnek projesine <https://github.com/hyperledger/iroha-ios/tree/master/Example>`__ gözatmalarını öneriyoruz.
Ayrıca yeni hesap yaratmak için bilgisayarınızda yerel olarak çalıştırmanız gereken Iroha eşleriyle bağlantı kurmaya çalışır ve bâzı varlık miktarını gönderir.
Projeyi çalıştırmak için, lütfen aşağıdaki adımları uygulayın:

- Docker konteynerindeki iroha eşini kurmak ve çalıştırmak için Iroha dökümantasyonundaki yönergeleri takip edin.

- `iroha-ios deposunu <https://github.com/hyperledger/iroha-ios>`__ klonlayın.

- cd Örnek dizini ve pod kurulumunu çalıştırın.

- XCode'daki IrohaCommunication.xcworkspace'i açın.

- IrohaExample hedefini kurun ve çalıştırın.

- Eğer senaryo başarıyla tamamlanırsa işlem geçmişini görmeyi düşününüz.

Örnek projeyle deneme yapmak açısından özgür hissedin ve Rocket.Chat'de herhangi bir soru sorma konusunda tereddüt etmeyin.