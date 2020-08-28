Hesap
=======

Bir Iroha varlığı belirtilen eylem kümesini gerçekleştirebilir.
Her hesap var olan `alanlardan <#domain>`__ birine aittir.

Bir hesabın birkaç `rolü <#role>`__ vardır (hiç rolü olmayabilir) — rolün buradaki anlamı erişim için verilen izinlerin topluluğudur.
Bir hesaba doğrudan yalnızca `verilebilir izinler <#grantable-permission>`__ atanır.


Varlık
======

Herhangi bir sayılabilir meta veya değer.
Her varlık var olan`alanlardan <#domain>`__ biri ile ilişkilidir.
Örneğin, bir varlık bu tür birimlerden herhangi biriyle temsil edilebilir - para birimi, bir külçe altın, emlak birimi, vb.

Blok
====

İşlem verisi blok adı verilen dosyaların içine kalıcı olarak kaydedilir.
Bloklar zamanla doğrusal bir sıra içerisinde düzenlenirler (ayrıca bu blok zinciri olarak da bilinir) [#f1]_.

Bloklar Iroha `eşlerinin <#peer>`__ kriptografik imzalarıyla imzalanır, `konsensüs <#consensus>`__ sırasında bu blok için oylama.
İmzalanabilir içerik yararlı yük olarak adlandırılır, böylece bloğun yapısı bunun gibidir:

.. image:: ../../image_assets/block.png
    :width: 80%
    :align: center
    :alt: Iroha Block Structure

*Dış yük*

    - signatures — eşlerin imzaları, which konsensüs turu boyunca blok için oy kullanmak

*İç yük*

    - height — bloğa kadar zincirdeki blokların sayısı
    - timestamp — eşler tarafından oluşturulmuş blokların Unix zamanı (milisaniye olarak)
    - doğrulama ve konsensüs adımlarından başarıyla geçmiş işlemlerin dizisi
    - zincirdeki önceki bloğun karışımı
    - rejected transactions hashes — durumsal doğrulama adımından geçememiş işlem karışımlarının dizisi; bu alan opsiyoneldir


Kullanıcı
=========

Iroha kullanan herhangi bir uygulama kullanıcı olarak kabul edilir.

Iroha'nın ayırt edici özelliği bütün kullanılıcılar bir eş ağı ile etkileşim halindeyken basit kullanıcı-server soyutlamalarını kullanıyor: blokzincir ile ilgili sistemler için spesifik olan herhangi bir soyutlamayı kullanmazlar.
Örneğin, Bitcoin'de kullanıcılar blokları doğrulamak zorundadırlar, veya HL Fabric'de blokta işlem yazıldığına emin olmak için bir kaç eş seçmeleri gerekir, halbuki HL Iroha'da kullanıcı herhangi bir eşle tek sunucudaki gibi etkileşime girer.

Komut
=====

Komut ağın `durumunu <#world-state-view>`__ değiştirme bir amacıdır.
Örneğin, Iroha'da yeni bir `rol <#role>`__ oluşturmak için `Create role <../develop/api/commands.html#create-role>`__ komutu vermek zorundasınızdır.

Konsensüs
=========

Konsensüs algoritması bilgisayar biliminde dağıtılmış süreçler veya sistemler arasında tek bir veri değeri üzerinde anlaşma sağlamak için kullanılan bir süreç.
Konsensüs algoritması çoklu güvenilmez düğümleri içeren ağlarda güvenilirliği sağlamak için dizayn edildi.
Dağıtılmış işlemlerde ve çok etmenli sistemlerde sorunu çözmek önemlidir -- konsensüs problemi olarak bilinir.

*Bir algoritma olarak Konsensüs*

Ağda eşler arasında blok üzerinde anlaşma sağlamak için olan bir algoritmadır. Sistemde ona sahip olarak güvenilirlik artar.

Iroha'nın bileşeni olarak konsensüs için, lütfen `bu link <architecture.html#block-consensus-yac>`_'i kontrol edin.

Alan
======

`Hesapları <#account>`__ ve `varlıkları <#asset>`__ gruplandırmak için yapılan soyutlamaya verilen isim.
Örneğin, Iroha ile çalışan organizasyonların grubundaki bir organizasyon temsil edilebilir.

Eş
===

Iroha ağının bir parçası olan bir düğüm.
`Konsensüs <#consensus>`_ sürecine katılır.

Yetkilendirme
=============


Komut vermek için ayrıcalık tanınan kurala verilen isimdir.
Yetkilendirme doğrudan bir `hesaba <#account>`__ **verilemez**, bunun yerine, hesapların izinlerinin bulunduğu rolleri vardır. Bir istisna olmasına rağmen, `Verilebilir izin <#grantable-permission>`__'e bakın.

`Iroha izinlerinin listesi <../develop/api/permissions.html>`_.

Verilebilir İzin
----------------

Yalnızca verilebilir izinler doğrudan `hesaba <#account>`__ verilebilir.
Verilebilir izinlere sahip bir hesap başka bir hesap adına bâzı belirli eylemleri yapmasına izin verilir.
Örneğin, eğer a@domain1 hesabı b@domain2 hesabına varlıkların transferi için izin veriyorsa — b@domain2 a@domain1'in varlıklarını herhangi birine transfer edebilir.

Öneri
========

Yalnızca `durumsuz doğrulamadan <#stateless-validation>`__ geçebilen `işlemlerin <#transaction>`__ kümesidir.

Doğrulanmış Öneri
-----------------

`Durumsuz <#stateless-validation>`__ ve `durumsal <#stateful-validation>`__ doğrulamanın her ikisinden de geçen fakat henüz işlenmeyen işlemlerin kümesi.

Sorgu
=====

Iroha'ya ağın `durumunu <architecture.html#world-state-view>`__ **değiştirmeyen** istek atmak.
Bir sorgu gerçekleştirerek, kullanıcı durumdan veri isteyebilir, örneğin hesabın bakiyesi, işlem geçmişi, vb.

Yeterli çoğunluk
================

İşlemlerin imzasının kaynağında, yeterli çoğunluk sayısı imzalanmış bir işlemi dikkate almak için gereken minimum imza miktarıdır.
Varsayılan değer 1'dir
`MST işlemleri <#multisignature-transactions>`__ için sayıyı arttırmanız gerekmektedir.

Her hesap ek genel anahtarlara bağlı olabilir ve kendi yeterli çoğunluk sayısını arttırabilir.

Rol
===

`Yetkilendirme <#permission>`__ kümesini tutan soyutlamaya verilen isim.

İmza Sahibi
===========

Bir `hesap <#account>`__ için çoklu imza işlemlerini onaylayan varlığı temsil eder.
`AddSignatory <../develop/api/commands.html#add-signatory>`__ aracılığıyla bir hesaba eklenebilir ve `RemoveSignatory <../develop/api/commands.html#remove-signatory>`__ aracığılıyla çıkarılablir.

İşlem
=====

Deftere atomik olarak uygulanan sıralı `komut <#command>`__ kümesi.
İşlem içinde geçerli olmayan herhangi bir komut doğrulama süreci boyunca bütün işlemin reddine yol açar.

İşlem Yapısı
------------

**Payload** imzalar harici bütün işlem alanlarını depolar:

    - Oluşturma süresi (milisaniye cinsinde unix zamanı)
    - İşlem oluşturucunun hesap ID'si (username@domain)
    - Yeterli çoğunluk alanı (gerekli imza sayısını gösterir)
    - `Komutlar bölümünde <../develop/api/commands.html>`__ detaylıca tanımlanmış tekrar eden komutlar
    - Toplu meta bilgisi (opsiyonel bölüm). Detay için `Toplu işlemler`_'e bakın


**İmzalar** bir veya daha çok imza içerir (ed25519 genel anahtar + imza)

Azalmış İşlem Karışımı
^^^^^^^^^^^^^^^^^^^^^^

Azalmış karışım toplu meta bilgisi hariç işlem yükü üzerinden hesaplanır.
`Toplu işlemler`_'de kullanılır.


İşlem Durumları
---------------

Hyperledger Iroha bir kullanıcı ile hem itme hem de çekme etkileşim modunu destekler.
Çekme modunu kullanan bir kullanıcı işlem karışımları göndererek Iroha eşinden yapılan işlemler hakkında durum güncellemeleri ister ve bir yanıt bekler.
Buna karşılık, itme etkileşimi her işlem için olay akışının dinlenmesiyle gerçekleştirilir.
Bu modlardan herhangi birinde, işlem durumları kümesi aynıdır:

 .. image:: ./../../image_assets/tx_status.png

.. not::
    Iroha'daki Durum akışı özelliği hakkında mükemmel bir `makale <https://medium.com/iroha-contributors/status-streaming-in-hl-iroha-5503487ffcfd>`_ yazdık.
    Göz atın ve yorumlarda ne düşündüğünüzü bize bildirin!

İşlem Status Kümesi
^^^^^^^^^^^^^^^^^^^^^^

 - NOT_RECEIVED: istek atılan eş bu işleme sahip değil.
 - ENOUGH_SIGNATURES_COLLECTED: yeterli imzalara sahip olan ve eş tarafından doğrulanacak olan bir çoklu imza işlemidir.
 - MST_PENDING: bu işlem daha fazla anahtar tarafından imzalanmak zorunda olan bir çoklu imza işlemidir (yeterli çoğunluk alanında talep edilen olarak).
 - MST_EXPIRED: bu işlem artık geçerli olmayan ve eş tarafından silinecek olan bir çoklu imza işlemidir.
 - STATELESS_VALIDATION_FAILED: işlem bâzı alanlar ile oluşturuldu, durumsuz doğrulama kısıtlamalarını karşılamıyor. İşlem gönderildikten hemen sonra bu durum işlemi oluşturan kullanıcıya geri döndürülür. Ayrıca nedenini de geri döndürür — hangi kuralı ihlal ettiğini.
 - STATELESS_VALIDATION_SUCCESS: işlem başarılı bir şekilde durumsuz doğrulamayı geçti. İşlem gönderildikten hemen sonra bu durum işlemi oluşturan kullanıcıya geri döndürülür.
 - STATEFUL_VALIDATION_FAILED: işlem doğrulama kurallarını ihlal eden, zincirin durumunu kontrol eden komutlara sahiptir (e.g. varlık bakiyesi, hesap izinleri vb.). Ayrıca nedenini de geri döndürür — hangi kuralı ihlal ettiğini.
 - STATEFUL_VALIDATION_SUCCESS: işlem başarılı bir şekilde durumsal doğrulamayı geçti.
 - COMMITTED: işlem yeterli oy almış ve şu anda blok depolama alanında olan bloğun bir parçasıdır. 
 - REJECTED: Bu işlem eş tarafından önceki konsensüs turunda durumsal doğrulama adımı sırasında reddedildi. Reddedilmiş işlemlerin karışımları `blok <#block>`__ depolama alanında tutuluyor. `Tekrar saldırıları <https://en.wikipedia.org/wiki/Replay_attack>`__ önlemek için gereklidir.

Bekleyen İşlemler
^^^^^^^^^^^^^^^^^

İşlem oluşturucu hesabının yeterli çoğunluğundan daha az imzaya sahip olan herhangi bir işlem beklemede olarak düşünülmektedir.
`Çok imzalı <#multisignature-transactions>`__ mekanizma yeterli çoğunluk için gereken miktarda imza toplar toplamaz bekleyen işlem `durumsal doğrulama`_ için gönderilir.

İşlem `toplu işlemler`_'in parçası ve tam olarak imzalanmamış işlemlerin var olduğu 
durumlarda yeterli çoğunluktaki imzaya sahip işlemlerin de ayrıca beklemede olduğu düşünülebilir.

Toplu İşlemler
==============

Toplu İşlemler kendi isteklerini korurken Iroha'ya aynı anda birkaç işlem gönderlimesini sağlayan bir özelliktir.

Toplu işlemlerdeki her bir işlem toplu meta bilgisini içerir.
Toplu meta toplu işlem türü tanımlayıcısı (atomik veya sıralı) ve toplu işlem içindeki bütün işlemlerin `azaltılmış karışımlar <#reduced-transaction-hash>`_'inin listesini içerir.
Karışımların sırası işlem sırasını tanımlar.

Toplu işlemler farklı hesaplar tarafından yaratılan işlemleri içerebilir.
Toplu işlemler içindeki herhangi bir işlem tekli veya `çoklu <#multisignature-transactions>`__ imzalar gerektirebilir (işlem yaratıcının hesabı için yeterli çoğunluk kümesine bağlıdır).
Toplu işlemler içindeki en az bir işlem toplu işlemlerin `durumsuz doğrulamayı`_ geçmesi için en az bir imzaya sahip olmalıdır.

`Medium <https://medium.com/iroha-contributors/batches-in-iroha-117614cf1e88>`__'da katılımcılarımızın sayfasından toplu işlemler hakkındaki makaleyi okuyabilirsiniz.

Atomik Toplu İşlemler
---------------------

Atomik toplu işlemlerdeki bütün işlemler toplu işlemlerin deftere uygulanabilmesi için `durumsal doğrulamayı`_ geçmelidir.

Sıralı Toplu İşlemler
---------------------

Sıralı toplu işlemler yalnızca deftere uygulanan işlem sırasını korur.
Toplu işlemlerde durumsal doğrulamayı geçebilen bütün işlemler deftere uygulanacaktır.
Bir işlemin doğrulama hatası doğrudan bütün toplu işlemlerin hatalı olduğu ANLAMINA GELMEZ.

Çok İmzalı İşlemler
===================

`Yeterli çoğunluğu`_ birden büyük bir işlem çok imzalı olarak düşünülür (ayrıca mst olarak adlandırılır).
`Doğrusal geçerliliği <#stateful-validation>`__ sağlamak için yaratıcı hesapların `imza sahipleri <#signatory>`__ tarafından onay gereklidir.
Bu katılımcılar imzaları ile aynı işlemi göndermeleri gerekir.

Doğrulama
=========

İki tür doğrulama vardır - durumsuz ve durumsal.

Durumsuz Doğrulama
------------------

`Torii <architecture.html#torii>`__'de icra edildi.
İmzalar dahil bir objenin iyi oluşturulup oluşturulmadığını kontrol eder.

Durumsal Doğrulama
------------------

`Verified Proposal Creator <#verified-proposal-creator>`__'da icra edildi.
`World State View <architecture.html#world-state-view>`__'e karşı geçerlidir.


.. [#f1] https://en.bitcoin.it/wiki/Block
