===
SSS
===

Yeniyim. Nereden başlamalıyım?
------------------------------

Merhaba, yeni başlayan arkadaşımız! Hoşgeldin :)
Iroha'ya başlaman için 2 yol vardır:

 1. `Başlangıç Kılavuzumuzu <../getting_started/index.html>`_ takip edip basit bir örnek ağ oluşturarak Iroha'nın nasıl çalıştığını görebilirsiniz
 2. `Irohanın temel kavramlarıyla <../concepts_architecture/index.html>`_ tanışabilirsiniz ve kendi `Iroha ağınızı <../deploy/index.html>`_ oluşturmaya başlayabilirsiniz

Şimdi Iroha blokzincirinize sahipsiniz! Tebrikler!
Eğer herhangi bir sorunuz olursa, topluluğumuzla buradan iletişime geçmekten çekinmeyiniz: https://chat.hyperledger.org/channel/iroha

Ne tip veri transfer edilebilir?
--------------------------------

Hyperleder Iroha yalnızca varlıkları değil (böyle varlıkları sunmak için çok gelişmiş komutlar ve sorgular kümesi nedeniyle böyle bir izlenim alabilirsiniz) aynı zamanda zincirde saklanacak verileri göndermenize izin verir.

Mevcut uygulama en azından `SetAccountDetail <../develop/api/commands.html#set-account-detail>`_ komutu ve `GetAccountDetail <../develop/api/queries.html#get-account-detail>`_ sorgusu aracılığıyla fırsat sağlar.

Mobil cihazlar düğüm olabilir mi?
---------------------------------

Mobil cihazla ne anlatmak istediğinize bağlı olarak iki seçenek vardır.

Eğer bâzı kurulu linux'larda (Raspberry PI gibi) veya tam yetkiye erişilmiş Android cihazla ARM tabanlı donanım hakkında konuşuyorsak, cihazda düğüm olarak (ağ içinde bir eş) Iroha'yı başlatmak mümkündür. Bu durumda, Iroha platform-yerel ikili olarak çalışacaktır.

Eğer dokunulmamış fabrika kabuğuyla (GUI) varsayılan iOS ve Android cihaz hakkında konuşuyorsak, genellikle mümkün değildir ve bununla ilişkin herhangi bir talimat sağlayamıyoruz. Buna rağmen hâlâ Iroha kullanan mobil uygulamalar yaratabilirsiniz. Iroha kullanıcıları olacaklar ve eş olarak hizmet vermeyecekler.

ARM cihazında Iroha çalıştırmak için hedef platformda oluşturmalısınız. Iroha kurulumu kayda değer miktarda RAM gerektirir - 32-bit ARM ana bilgisayar için 8GB RAM'e ihtiyaç duyacaksınız. Kurulum Docker konteynerin içinde gerçekleştirilebilir. Konteyneri hazırlamak için şunlara ihtiyaç duyacaksınız:

1. Iroha git repo klonu: https://github.com/hyperledger/iroha
2. `iroha/docker/develop`'un içinde `docker build -t iroha-build-env .`'ı çalıştırın 
3. Yeni oluşturulan konteyneri çalıştırın ve oraya Iroha'nın kendisini kurun

Lütfen konteynere Iroha git deposuyla dosya yüklemeyi unutmayın 

Verim nedir (TPS)? Performans testi sonuçları var mı?
---------------------------------------------------------------------

Iroha ağınızın verimi konfigürasyona bağlı olacaktır, donanım ve düğüm sayısı.
`test/load` dizinindeki yük testini deneyebilir ve sonuçları raporlayabilirsiniz.

.. not::Buraya sık sık yeni sorular ekleyeceğiz!
