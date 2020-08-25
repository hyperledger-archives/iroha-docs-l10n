.. _integrations:

================
Entegre Projeler
================

Hyperledger Konsorsiyumu'nun fikirlerinden biri mümkün olan en iyi blokzincir deneyimi sunmak için birlikte çalışılabilecek çözümler yaratmaktır. Iroha'da diğer müthiş Hyperledger araçlarının ve çözümlerinin entegrasyonu kullanım durumlarınız için daha iyi Iroha yaratmaya bir yol olduğuna inanıyoruz.
Bu nedenle birçok projeyle entegrasyon üzerinde çalışıyoruz ve Iroha'nın neyle çalışabileceği hakkında size daha fazla bilgi vermek isteriz.

Hyperledger Ursa
================

`Hyperledger Ursa <https://wiki.hyperledger.org/display/ursa/Hyperledger+Ursa>`_ diğer kriptografik çalışmaları kopyalamaktan kaçınmak için insanları (ve projeleri) etkin kılan paylaşılan bir kriptografik kütüphanedir ve umuyoruz ki süreç içerisinde güvenliği artar.
Kütüphane projelerin (ve potansiyel olarak diğerlerinin) kripto yerleştirmesi ve kullanması için bir kayıt olma depolama alanıdır.
Hyperledger Ursa kriptografik kod uygulamalarına veya kriptografik kod arayüzlerine uyumlu olan alt projelerden oluşur.

Sadece `oluşturma sırasında bir bayrak <../build/index.html#main-parameters>`_ ekleyerek Ursa kütüphanesiyle kolayca Iroha oluşturabilirsiniz.
Standart Iroha kriptografileri yerine Ursa kütüphanesinden kripto algoritmaları kullanmanıza izin verir.
Ursa'daki yeni kütüphanelerin gelişmesiyle sizin için gitgide daha fazla seçenek mevcut olacak!

.. not::
	Şu anda, sadece Ursa'dan ed25519 SHA-2 algoritmasını aldık.
	Eğer hoşunuza giderse, daha fazla seçenek eklemek için koda katkıda bulunabilirsiniz.

Varsayılan ed25519/sha3 şifreleme algoritmasıyla birlikte Ursa'nınkinin de kullanılmasına izin vermek için, ikincisi için çoklu karışım genel anahtar formatını kullanıyoruz.
`anahtarlar <../develop/keys.html>`_ hakkında daha fazla bilgi öğrenebilirsiniz.

Hyperledger Gezgini
===================

`Hyperledger Gezgini <https://wiki.hyperledger.org/display/explorer>`_ bir blokzincir modülüdür ve Hyperledger projelerinden biri The Linux Foundation tarafından düzenlenmektedir.
Kullanıcı dostu bir Web uygulaması oluşturmak için tasarlanan Hyperledger Gezgini blokları, işlemleri ve ilişkili verileri, ağ bilgilerini (isim, durum, düğümlerin listesi), zincir kodlarını ve işlem familyalarını görüntüleyebilir, çağırabilir, dağıtabilir veya sorgulayabilir bununla birlikte defterde diğer ilgili bilgiler saklanır.

`Buradan <https://github.com/turuslan/blockchain-explorer/blob/iroha-explorer-integration/iroha-explorer-integration.md>`_ Iroha ile nasıl gezgin kullanabileceğinizi öğrenebilirsiniz.

Hyperledger Burrow
==================

`Hyperledger Burrow <https://wiki.hyperledger.org/display/burrow>`_ Ethereum Sanal Makinesinin (EVM) spesifikasyonuna göre kısmen geliştirilmiş izin verilen bir akıllı sözleşme tercümanıyla modüler bir blokzincir kullanıcısı sağlar.

Böylece, HL Burrow ile Iroha'da Solidity akıllı sözleşmeleri kullanabilirsiniz.
Daha fazla bilgi edinmek için aşağıya tıklayın.

.. toctree::
    :maxdepth: 2

    burrow.rst
    burrow_example.rst
