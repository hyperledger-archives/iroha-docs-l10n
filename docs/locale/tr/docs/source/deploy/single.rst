==========================
Tekli örnekleri çalıştırma
==========================

Genellikle, API'yı denemek ve kabiliyetlerini keşfetmek için Iroha'yı yerel olarak çalıştırmak ister.
Bu yerel veya konteyner ortamında yapılabilir (Docker).
Her iki olası durumu da inceleyeceğiz,
fakat eş bileşenleri dağılımını basitleştirmek için, *Docker'ı makinenize kurmanız tavsiye edilir*.

Yerel ortam
-----------

Yerel ortam tarafından, arka plan sürecinin ve Postgres'in herhangi bir konteyner olmaksızın dağıtılması amaçlanmaktadır.
Docker ile uğraşmanın tercih edilmediği durumlarda bu yardımcı olabilir — genellikle özelliklerin hızlı bir şekilde araştırılması.

Postgres sunucusu çalıştırma
""""""""""""""""""""""""""""

Yerel olarak postgres sunucusunu çalıştırmak için, you postgres `websitesini <https://www.postgresql.org/docs/current/static/server-start.html>`__ kontrol etmelisiniz ve yönergeleri takip etmelisiniz.
Genellikle, sistem başladığında postgres sunucusu otomatik olarak çalışır, fakat bu sistemin yapılandırmasında kontrol edilmelidir.


İroha arkaplanı çalıştırma (irohad)
"""""""""""""""""""""""""""""""""""

İlerlemeden önce yapmanız gereken ön koşulların bir listesi var:

 * Postgres sunucusunun hazırlanır ve çalıştırılır
 * `irohad` Iroha arkaplan ikilisi kurulur ve sisteminizde erişebilir haldedir
 * Genesis blok ve yapılandırma dosyaları oluşturur
 * Yapılandırma dosyası geçerli postgres bağlantı ayarlarını kullanır
 * Eşler için bir anahtar çifti oluşturulur
 * Bu eş üzerinde Iroha'yı ilk kez çalıştırıyorsunuz ve yeni bir zincir oluşturmak istiyorsunuz

.. İpucu:: Varsayımlar listesindekiyle aynı olmayan birşey var mı? Lütfen, :ref:`deploy_troubles` bölümüne bakınız.

Geçerli varsayımlar durumunda, geri kalan tek şey parametreleri takip ederek arkaplan sürecini başlatmaktır:

+---------------+-----------------------------------------------------------------+
| Parametre     | Anlamı                                                          |
+---------------+-----------------------------------------------------------------+
| config        | yapılandırma dosyası, sistemi ayarlamak için postgres           |
|               | bağlantısı ve değerleri içerir                                  |
+---------------+-----------------------------------------------------------------+
| genesis_block | defterdeki başlangıç bloğu                                      |
+---------------+-----------------------------------------------------------------+
| keypair_name  | dosya uzantısı olmaksızın özel ve genel anahtar dosya isimleri, |
|               | blokları imzalamak için eş tarafından kullanılır                |
+---------------+-----------------------------------------------------------------+

.. Dikkat:: Defterde zaten mevcut bloklar ile `--genesis_block` kullanarak yeni genesis bloklarını belirlemek için `--overwrite_ledger` bayrağının ayarlanması gerekir. Aksi takdirde arkaplan programı başarısız olur.

Kabuk komutuna bir örnek olarak, Iroha arkaplan programı çalıştırmak:

.. code-block:: shell

    irohad --config example/config.sample --genesis_block example/genesis.block --keypair_name example/node0

.. Not:: `HL Ursa support <../integrations/index.html#hyperledger-ursa>`_ ile oluşturulmuş bir Iroha çalıştırıyorsanız lütfen `example/ursa-keys/`'deki örnek anahtarlar ve genesis blokları edinin.

.. Dikkat:: Arkaplan programını durdurduysanız ve var olan zincirleri kullanmayı istiyorsanız — genesis blok parametresini geçmemelisiniz.


Docker
------

Docker'da tek bir örnek olarak Iroha eşlerini çalıştırmak için, öncelikle Iroha için görüntüsünü çekmelisiniz:

.. code-block:: shell

    docker pull hyperledger/iroha:latest

.. İpucu:: En son kararlı sürüm için *en son* etiketi kullanın ve en son geliştirme sürümü için *geliştirin*

Ardından, görüntüyü problemsiz çalıştırmak için bir ortam oluşturmalısınız:

Docker ağı yaratın
""""""""""""""""""

Birbirilerine erişebilir olmak için, Postgres ve Iroha için konteynerler aynı sanal ağda çalışmalıdır.
Aşağıdaki komutu yazarak bir ağ yaratmak (ağ için herhangi bir isim kullanabilirsiniz, fakat biz örnekte *iroha-network* ismini kullandık):

.. code-block:: shell

    docker network create iroha-network

Bir konteynerde Postgresql çalıştırmak
"""""""""""""""""""""""""""""""""""""""

Benzer şekilde postgres sunucusunu çalıştırın daha önce yarattığınız ağa ekleyin ve iletişim için bağlantı noktalarını açın:

.. code-block:: shell

    docker run --name some-postgres \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=mysecretpassword \
    -p 5432:5432 \
    --network=iroha-network \
    -d postgres:9.5

Blok depolama alanı için disk bölümü yaratmak
"""""""""""""""""""""""""""""""""""""""""""""

Konteynerde iroha arkaplan programı çalıştırmadan önce, dosyaları depolamak ve zincir için blokları depolamak için kalıcı bir disk bölümü yaratmalıyız.
Aşağıdaki komut aracılığıyla yapılır:

.. code-block:: shell

    docker volume create blockstore

Docker konteynerinde iroha arkaplan programı çalıştırmak 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Devam etmeden önce gözden geçirmeniz gereken varsayımların bir listesi vardır:
 * Postgres sunucusu aynı docker ağında çalışıyor
 * Tek bir düğüm için yapılandırma dosyası ve anahtar çiftini içeren bir dosya vardır 
 * Bu eş üzerinde ilk kez Iroha'yı çalıştırıyorsunuz ve yeni bir zincir eklemek istiyorsunuz

Eğer karşılaşırlarsa aşağıdaki komutlar ile ilerleyebilirsiniz:

.. code-block:: shell

    docker run --name iroha \
    # External port
    -p 50051:50051 \
    # Folder with configuration files
    -v ~/Developer/iroha/example:/opt/iroha_data \
    # Blockstore volume
    -v blockstore:/tmp/block_store \
    # Postgres settings
    -e POSTGRES_HOST='some-postgres' \
    -e POSTGRES_PORT='5432' \
    -e POSTGRES_PASSWORD='mysecretpassword' \
    -e POSTGRES_USER='postgres' \
    # Node keypair name
    -e KEY='node0' \
    # Docker network name
    --network=iroha-network \
    hyperledger/iroha:latest

