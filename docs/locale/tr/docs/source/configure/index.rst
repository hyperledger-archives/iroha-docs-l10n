.. _configuration:

============
Yapılandırma
============

.. toctree::
      :maxdepth: 1

      torii-tls.rst

Bu bölümde Iroha'yı nasıl yapılandıracağımızı anlayacağız. ``example/config.sample``'a bakalım.

.. code-block:: javascript
  :linenos:

  {
    "block_store_path": "/tmp/block_store/",
    "torii_port": 50051,
    "torii_tls_params": {
      "port": 55552,
      "key_pair_path": "/path/to/the/keypair"
    },
    "internal_port": 10001,
    "pg_opt": "host=localhost port=5432 user=postgres password=mysecretpassword dbname=iroha",
    "database": {
      "host": "localhost",
      "port": 5432,
      "user": "postgres",
      "password": "mysecretpassword",
      "working database": "iroha_data",
      "maintenance database": "postgres"
    },
    "max_proposal_size": 10,
    "proposal_delay": 5000,
    "vote_delay": 5000,
    "mst_enable" : false,
    "mst_expiration_time" : 1440,
    "max_rounds_delay": 3000,
    "stale_stream_max_rounds": 2,
    "utility_service": {
      "ip": "127.0.0.1",
      "port": 11001
    }
  }

gördüğünüz gibi, yapılandırma dosyası ``json`` yapısında geçerlidir. Satır satır 
gidelim ve bütün parametrelerin ne anlama geldiğini anlayalım.

Yayılma-spesifik parametreler
==============================

- ``block_store_path`` blokların depolandığı dosyaya yol kurar.
- ``torii_port`` harici iletişim için port kurar. Sorgular ve
  işlemler burada gönderilir.
- ``internal_port`` dahili iletişim için port kurar: ordering
  service, konsensüs ve blok yükleyici.
- ``database`` (opsiyonel) veritabanı yapılandırmasını kurmak için kullanılır (aşağıya bakınız)
- ``pg_opt`` (opsiyonel) PostgreSQL'nin kimlik ayarlarının artık kullanılmayan bir yolu:
  bilgisayar adı, port, kullanıcı adı, şifre ve veritabanı adı.
  Veritabanı adı hariç bütün veriler zorunludur.
  Eğer veritabanı adı verilmemişsde, ``iroha_default`` olarak varsayılan bir isim kullanılır.
- ``log`` günlük çıktı ayrıntısı ve formatını kontrol eden opsiyonel bir parametre (aşağıya bakınız).
- ``utility_service`` (opsiyonel) bakım görevleri için bitiş noktası.
  Mevcutsa bağlanacak ``ip`` adresi ve ``port`` içermelidir.
  Bakım bitiş noktalarının kullanım örneği için `shepherd docs <../maintenance/shepherd.html>`'a göz atınız.

Ayrıca kullanıcı iletişimi için TLS desteğini etkinleşirmek için yapılandırmada dahil 
edilebilir opsiyonel bir ``torii_tls_params`` parametresi vardır.

Burada, ``port`` TLS sunucusu bağlanacak TCP portudur ve
``key_pair_path`` anahtar çiftine eklenmesi gereken bir formata giden bir yoldur
``.crt`` PEM-kodlu sertifikaya giden ve eklenmiş bir yoldur
``.key`` bu sertifika için PEM-kodlu özel anahtara giden bir yoldur
(e.g. if ``key_pair_path`` is ``"/path/to/the/keypair"`` iroha sertifika için
bu konum bakar ``"/path/to/the/keypair.crt"`` ve anahtar için de bu konuma
``"/path/to/the/keypair.key"``)

.. warning::
   Yapılandırma alanı ``pg_opt`` kullanımdan kaldırıldı, lütfen ``database`` bölümünü kullanın!

   Yapılandırmada ikisi de sağlandığında ``database`` bölümü ``pg_opt``'ı geçersiz kılar.

   ``pg_opt`` ve ``database`` alanlarının her ikisi de opsiyoneldir, fakat en az biri belirlenmelidir.

``database`` bölümü alanları:

- ``host`` PostgreSQL bağlantısı için kullanılacak ana bilgisayar
- ``port`` PostgreSQL bağlantısı için kullanılacak port
- ``user`` PostgreSQL bağlantısı için kullanılacak kullanıcı
- ``password`` PostgreSQL bağlantısı için kullanılacak şifre
- ``working database`` world state view ve opsiyonel blokları depolamak için kullanılan veritabanı adıdır.
- ``maintenance database`` veritabanının çalışması sağlamak için kullanılan veritabanı adıdır.
  Örneğin, iroha çalışan veritabanını yaratmaya veya kaldırmaya ihtiyaç duydugunda, PostgreSQL bağlanmak için başka bir veritabanı kullanmalıdır.

Ortam-spesifik parametreler
===========================

- ``max_proposal_size`` is the maximum amount of transactions tek bir öneride olabilecek 
  işlemlerin maksimum miktarıdır ve sonuç olarak tek bir blokta da. Böylece, bu değeri
  değiştirerek potansiyel blok boyutunu tanımlayabilirsiniz. Başlangıç için ``10``'u deneyebilirsiniz. 
  Fakat, eğer saniye başına bir çok işleminiz varsa bu sayıyı arttırmanızı 
  öneririz.
- ``proposal_delay`` Bir eşin öneriyle orderding service'den beklediği yanıtın 
  milisaniye cinsinden bir zaman aşımıdır.
- ``vote_delay`` bir sonraki eşe oy gönderilmeden önce milisaniye cinsinden 
  bekleme zamanıdır. En uygun değer büyük ölçüde ağdaki Iroha eşlerinin miktarına 
  bağlıdır. (daha fazla sayıda düğüm daha uzun ``vote_delay`` gerektirir). 100-1000 
  milisaniye ile başlamanızı öneriyoruz.
- ``mst_enable`` Iroha'da çok imzalı işlemler ağ ulaşımını etkinleştirir 
  veya devre dışı bırakır.
  Bayrak ``false`` olarak belirlendiğinde dahi MST motoru herhangi bir 
  eş için her zaman çalışır.
  Bayrak eşler arasında MST işlemleri hakkında yalnızca bilgi 
  paylaşımına olanak sağlar.
- ``mst_expiration_time`` tamamen imzalanmamış bir işin (veya bir toplu işin) 
  süresinin dolduğu kabul edilen süreyi (dakika cinsinde) belirten opsiyonel 
  bir parametredir.
  Varsayılan değer 1440'dır.
- ``max_rounds_delay`` iki konsensüs turu arasındaki maksimum gecikmeyi 
  belirten (milisaniye cinsinden) opsiyonel bir parametredir.
  Varsayılan değer 3000'dir.
  Iroha boştayken, CPU, ağ ve kayıt yükünü azaltmak için kademeli olarak 
  gecikmeyi arttırır.
  Fakat uzunca boşta kaldıktan sonra ilk işlem vardığında çok uzun gecikmeler istenmeyebilir.
  Bu parametre kaynak tüketimi ve boşta kalma süresinden sonra çalışmaya geri 
  dönmenin gecikmesi arasındaki feragat etmede en uygun değeri 
  bulmaya olanak sağlar.
- ``stale_stream_max_rounds`` durum güncellemesi bildirilmemişken durum akışını 
  açık tutmak için maksimum tur miktarını belirten opsiyonel bir parametredir.
  Varsayılan değer 2'dir.
  Bu değerin artması bâzı nedenlerden dolayı yeni turlarla güncellenmezse 
  kullanıcının işlemi izlemek için yeniden bağlanma süresini azaltır.
  Fakat büyük değerler her turda bağlanmış kullanıcıların ortalama sayısını yükseltir.
- ``"initial_peers`` genesis bloktan eşler yerine başlangıçtan sonra bir düğümü 
  kullanacak olan eşlerin listesini belirten opsiyonel bir parametredir.
  Başlangıçta kötü niyetli olabilecek eşlerin çoğu ağa yeni bir düğüm eklediğinizde 
  kullanışlı olabilirler.
  Eşlerin listesi bir JSON dizisi olarak sağlanmalıdır:

  ``"initial_peers" : [{"address":"127.0.0.1:10001", "public_key":
  "bddd58404d1315e0eb27902c5d7c8eb0602c16238f005773df406bc191308929"}]``

İşlem geçmişi saklama
=====================

Iroha'da işlem geçmişi saklama istediğiniz kadar ayrıtılı şekilde ayarlanabilir. 
Her bileşen yapılandırma dosyası sayesinde geçersiz kılınabilen ana proseslerinden 
gelen kalıtımsal özelliklerle kendi işlem geçmişi saklama yapılandırmasına sahiptir.
Bunun anlamı bütün bileşen İşlem geçmişi saklayıcıları tek bir kök ile bir ağaçta organizelerdir.
Yapılandırma dosyasının ilgili bölümü geçersiz kılma değerlerini kapsar:

.. code-block:: javascript
  :linenos:

  "log": {
    "level": "info",
    "patterns": {
      "debug": "don't panic, it's %v.",
      "error": "MAMA MIA! %v!!!"
    },
    "children": {
      "KeysManager": {
        "level": "trace"
      },
      "Irohad": {
        "children": {
          "Storage": {
            "level": "trace",
            "patterns": {
              "debug": "thread %t: %v."
            }
          }
        }
      }
    }
  }

Bu yapılandırma bölümünün bütün kısımları opsiyoneldir.

- ``level`` ayrıntı düzeyini belirler.
  Kullanılabilir değerler (ayrıntı düzeyinin düşmesinde):

  - ``trace`` - herşeyi yazdırır
  - ``debug``
  - ``info``
  - ``warning``
  - ``error``
  - ``critical`` - sadece kritik mesajları yazdırır

- ``patterns`` farklı ayrıntı seviyeleri için her işlem geçmişi dizesinin 
  biçimlendirmesini kontrol eder.
  Her değer daha az ayrıntı seviyesini de geçersiz kılar.
  Yani yukardaki örnekte, "panik yapma" modeli ayrıca bilgi ve uyarı seviyesi
  için de geçerlidir ve izleme seviyesi modeli yapılandırmada başlatılmayan
  tek modeldir (varsayılan manuel yazılmış değere ayarlanacaktır).
- ``children`` alt proses düğümlerin geçersiz kılınmalarını açıklar.
  Anahtarlar bileşenlerin isimleridir ve değerler kök işlem geçmişi yapılandırmasında 
  olduğu gibi aynı sözdizimi ve semantiğe sahiptir.
