.. _architecture:

Iroha'da neler var?
====================

HL Iroha ağı düğümler arasında bağlantı sağlayan birkaç temel bileşenden meydana gelir. Bunları aşağıda öğrenebilirsiniz.

.. image:: ../../image_assets/pipeline-diagram.png
	:width: 80%
	:align: center
	:alt: Iroha Architecture Diagram

Torii
-----

⛩

`clients <glossary.html#client>`__ için giriş noktası.
Ulaşım olarak gRPC kullanın.
Iroha ile etkileşim için herhangi biri gRPC'nin bitiş noktalarını kullanabilir, `Commands <../develop/api/commands.html>`__ ve `Queries <../develop/api/queries.html>`__ bölümünde tanımlanmıştır, veya `client libraries <../develop/libraries.html>`__ 'u kullanabilirsiniz.

MST İşlemci
-------------

*Multisignature Transactions Processor*

`Gossip protocol <https://en.wikipedia.org/wiki/Gossip_protocol>`_ ile diğer kullanıcılarda mesaj gönderip mesaj alan dahili bir gRPC servisidir.
Misyonu  `yeterli sayıya <glossary.html#quorum>`_ ulaşılana kadar yeterli sayıda imza almayanlara `çoklu imza işlemleri <glossary.html#multisignature-transactions>`_ göndermektir.

Eş İletişim Servisi
-------------------

Iroha'nın iç bileşeni - `işlemi <glossary.html#transaction>`__ `Torii <#torii>`__'dan `Ordering Gate <#ordering-gate>`__'e `MstProcessor <#MstProcessor>`_ ile ileten bir aracı.
PCS'nin esas amacı konsensüs uygulaması ile etkileşimin karmaşılığını gizlemektir.

Ordering Gate
-------------

`İşlemleri <glossary.html#transaction>`__ `Eş İletişim Servisi <#peer-communication-service>`__ 'den `Ordering Service <#ordering-service>`__ 'e aktaran dahili bir Iroha bileşenidir (gRPC kullanıcısı).
Ordering Gate `önerileri <glossary.html#proposal>`_ Ordering Service'den alır (zincirdeki potansiyel bloklar) ve `durumsal doğrulama <glossary.html#stateful-validation>`__ için `Simulator <#simulator>`__'e gönderir.
Ayrıca konsensüs turuna göre Ordering Service'den öneri talebinde bulunur.

Ordering Service
----------------

Diğer `eşlerden <glossary.html#peer>`__ mesajlar alan ve `durumsuz doğrulamadan <glossary.html#stateless-validation>`__ geçirilen birkaç `işlemi <glossary.html#transaction>`__ bir `öneriye <glossary.html#proposal>`__ birleştiren dahili Iroha bileşenidir. (gRPC sunucusu)
Her düğüm kendi ordering service'ine sahiptir.
Öneri oluşturmak aşağıdaki olaylardan birini tetikleyebilir:

1. İşlem koleksiyonu için ayırılan zaman sınırının süresi doldu.

2. Ordering service tek bir öneri için izin verilen maksimum işlem miktarını alır.

Her iki parametre (zamanaşımı ve önerinin maksimum boyutu) yapılandırılabilir (`environment-specific parameters <../configure/index.html#environment-specific-parameters>`_ sayfasını kontrol ediniz).

Her iki tetikleme için de ortak önkoşul en az bir işlem ordering service'e ulaşmasıdır.
Aksi takdirde, öneri oluşturulmaz.

Ayrıca Ordering service önerinin ön doğrulamasını gerçekleştirir (örneğin durumsuz reddedilen işlemleri Öneriden silmek).

Doğrulanmış Öneri Yaratıcı
--------------------------

Dahili Iroha bileşeni `Ordering Service <#ordering-service>`_ 'den alınmış `öneriyi <glossary.html#proposal>`__ içeren `işlemlerin <glossary.html#transaction>`__ `durumsal doğrulamasını <glossary.html#stateful-validation>`_ gerçekleştirir.
Durumsal doğrulamadan geçen işlemler bazında **doğrulanmış öneri** oluşturulacak ve `Blok Yaratıcı <#block-creator>`__'ya geçecek.
Durumsal doğrulamadan geçemeyen bütün işlemler kaldırılacak ve doğrulanmış öneriye dahil edilmeyecek.

Blok Yaratıcı
-------------

Sistem bileşeni `konsensüs <#consensus>`__'e daha fazla yayılmak için `durumsuz <glossary.html#stateless-validation>`__ ve `durumsal <glossary.html#stateful-validation>`__ doğrulamadan geçen işlemlerin kümesinden bir blok oluşturur.

Blok yaratıcı, `Doğrulanmış Öneri Yaratıcı <#verified-proposal-creator>`_ ile birlikte `Simulator <https://github.com/hyperledger/iroha/tree/master/irohad/simulator>`_ adı verilen bir bileşen oluşturur.

Blok Konsensüs (YAC)
---------------------

*Bir bileşen olarak Konsensüs*

Konsensüs blokzincirin kalbidir - eş ağı içerisinde `eşler <glossary.html#peer>`__ arasındaki tutarlı durumu korur.
Iroha, Yet Another Consensus (aka YAC) adı verilen kendi konsensüs algoritmasını kullanır.

Konsensüs ve özellikle YAC ilkelerinin kapsamlı açıklamasını içeren videoya `buradan <https://youtu.be/mzuAbalxOKo>`__. göz atabilirsiniz.

YAC algoritmasının belirgin özellikleri ölçeklenebilirlikleri, performansı ve Çarpışma hatası toleransıdır.

Ağda tutarlılığı sağlamak için, eğer eksik bloklar varsa, `Senkronizör <#synchronizer>`__ aracılığıyla diğer eşten yükleyecekler.
İşlenmiş bloklar `Ametsuchi <#ametsuchi>`__ blok depolama alanında saklanır.

Konsensüsün genel tanımı için, lütfen `bu linki <glossary.html#consensus>`_ kontrol ediniz.


Senkronizör
------------

`Konsensüsün <#consensus>`__ bir parçası.
`Eş <glossary.html#peer>`__ zincirlerine eksik bloklar ekler (tutarlılığı korumak için diğer eşlerden yüklerler).

Ametsuchi Blockstore
--------------------

Blokları depolayan ve bloklardan durum üreten `World State View <#world-state-view>`__ adı verilen Iroha depolama bileşenidir.
`Kullanıcı <glossary.html#client>`__ için doğrudan Ametsuchi ile etkileşime geçmenin yolu yoktur.


World State View
----------------

WSV sistemin mevcut durumunu yansıtır, ayrıca anlık görüntü olarak da kabul edilir.
Örnek vermek gerekirse, WSV şu anda var olan fakat `işlem <glossary.html#transaction>`__ 
akışının bilgi geçmişi bulunmayan bir `hesabın <glossary.html#account>`__ 
`varlıklarının <glossary.html#asset>`__ miktarı hakkında bilgi tutar.
