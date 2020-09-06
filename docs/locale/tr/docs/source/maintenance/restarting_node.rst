.. raw:: html

    <style> .red {color:#aa0060; font-weight:bold; font-size:16px} </style>

.. role:: red

Var olan WSV ile Iroha düğümünü yeniden başlatma
================================================

Önceden, bir düğümü güncellemeniz veya bâzı nedenlerden dolayı kapatılması durumunda, tutarlı `world state view (aka WSV) <../concepts_architecture/architecture.html#world-state-view>`__'ı yeniden yaratmak için bütün blokları yeniden okumanın yalnızca bir seçeneği vardı.
Bir düğümü daha hızlı başlatmak için, hızlı bir kontrolden sonra var olan bir WSV veritabanını yeniden kullanmak mümkündür.
Bunun için, üst bloğun ``hash``'i ve the blok depolama alanının ``height``'ı WSV'ye dahil edildi.

.. uyarı::
	WSV'nin manuel bir şekilde düzenlenmediğinden emin olmak düğümün Yöneticilerine kalmıştır – yalnızca Iroha veya `geçiş betiği <#changing-iroha-version-migration>`__ tarafından.
	Manuel düzenleme veya geçiş betiğinin düzenlenmesi tutarsız bir ağa neden olabilecek güvenilir bir kılavuzu takip etmez.
	Sadece kendi sorumluluğunuzdadır (sizi uyardık).

Bâzı durumlar için harika bir fikir olmasına rağmen, lütfen blok depolama alanından geri yüklemeye kıyasla WSV yeniden kullanımının belirli detayları olduğunu düşünün:

| :red:`Trust point`
| **WSV'yi yeniden kullanmak:** hem blok depolama alanına hem de WSV'ye güvenmemiz gerekir.
| **Blok depolama alanından WSV'yi restore etmek:** sadece genesis bloğuna güveniyoruz.


| :red:`Integrity`
| **WSV'yi yeniden kullanmak:** blok depolama alanı ve WSV birbirleriyle eşleşmelidir! Iroha bunu kontrol etmeyecek.
| **Blok depolama alanından WSV'yi restore etmek:** WSV'yi restore ederken Iroha her bloğu kontrol edecek.
	Blok depolama alanındaki herhangi bir hata bulunacak (elbette genesis blok hariç).
	WSV ile blok depolama alanının eşleşeceği garanti edilir.

| :red:`Time`
| **WSV'yi yeniden kullanmak:** Iroha hemen ağda çalışmaya hazırdır.
| **Blok depolama alanından WSV'yi restore etmek:** daha büyük blok depolama alanı - restore edilmesi ve çalışmaya başlaması daha uzun sürer.

.. not:: Eğer kapanan yerel defterde olması gerekenden daha fazla blok varsa ve bunlar arasında doğru WSV varsa - herşey yolundadır, Iroha doğru bloğun WSV'sini alacaktırs.
	Eğer bloklar olması gerekenden daha azsa – WSV'yi yeniden kullanma seçeneği sizin için çalışmayacaktır.
	Lütfen, bloklardan geri yükleyin.


WSV'nin Yeniden Kullanımını Etkinleştirmek
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Eğer WSV durumunu yeniden kullanmak istiyorsanız, `--reuse_state` bayrağı ile Iroha'yı başlatınız.
Bu bayrak verildiğinde, eğer sebep ne olursa olsun başlamak başarısız olursa Iroha sıfırlama veya durum veritabanının üzerine yazma yapmayacaktır.


WSV'nin Yeniden Kullanımını Etkinleştirmek
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Eğer WSV durumunu yeniden kullanmak istiyorsanız, `--reuse_state` bayrağı ile Iroha'yı başlatınız.
Bu bayrak verildiğinde, eğer sebep ne olursa olsun başlamak başarısız olursa Iroha sıfırlama veya durum veritabanının üzerine yazma yapmayacaktır.

Durum Veritabanı Şema versiyonu
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Var olan WSV'yi yeniden kullanırken, Iroha bir şema versiyonu uyumluluk kontrolü gerçekleştirir.
Eğer şema kullanılan Iroha ile uyumlu değilse veritabanını başlatmayacak veya bir şekilde değiştirmeyecek.

Eğer şemanız Iroha versiyon v1.1.1 veya daha altı tarafından yaratıldıysa, büyük ihtimalle versiyon bilgisini içermez.
Bu durumda manuel bir şekilde eklemeniz gerekir.
Betiğimizi bu amaç için kullanmanız teşvik edilir, `burada <https://github.com/hyperledger/iroha-state-migration-tool/blob/master/state_migration.py>`__ bulunur.s
Zor kullanarak şema versiyonunuzu ayarlamak için (örneğin herhangi bir `geçiş süreci <#changing-iroha-version-migration>`__ olmaksızın), `--force_schema_version` bayrağı ile betiği başlatın ve şemanızı yaratmak için kullanılan Iroha ikili versiyonunu geçin.

.. uyarı::

  Şema versiyon numaralarını zorla yazmadan önce, şemayı yaratan irohad versiyonunu iki kez kontrol ediniz.
  Şema numaralarını zorladığınızda hiç bir kontrol yapılmaz, bu nedenle gelecekte (sonraki geçiş boyunca) durum veritabanını kırmak kolaydır.

Iroha versiyonunu değiştirmek. Geçiş.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
WSV'yi saklarken Iroha versiyonunu değiştirmek isterseniz bir geçiş gerçekleştirmeniz önerilir.
Gereksiz olabilmesine rağmen (Iroha, şema uyumsuzsa başlatmayı reddedecektir), genel bir kural olarak,  şemayı her versiyonda geliştiririz ve daha iyi bir performans için geçiş iyi bir fikir olabilir.
Bunun için standart `PostgreSQL kılavuzunu <https://www.postgresql.org/docs/current/backup.html>`__ kullanarak geçişten önce bir veritabanı yedeklemesi gerçekleştirmeniz önerilir.

Geçişi gerçekleştirmek için, lütfen `betiğimizi <https://github.com/hyperledger/iroha-state-migration-tool/blob/master/state_migration.py>`__ kullanınız.

Şema bilgilerini veritabanından yükler ve geçiş adımlarıyla eşleştirir (varsayılan olarak, geçiş senaryoları migration_data dizininde betik olarak aynı dosyada tanımlanır).
Sonrasında, veritabanınızı istenen sürüme getirecek ve birini seçmenizi isteyecek tüm geçiş yollarını bulacak.

.. seealso::
	`Here <https://github.com/hyperledger/iroha-state-migration-tool/blob/master/README.md>`_ are some details about different migration cases and examples you can check out to perform migration
