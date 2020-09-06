.. _getting-started:

========================
Hızlı Başlangıç Kılavuzu
========================

Bu kılavuzda, çok basit bir Iroha ağı yaratacağız, başlatacağız, işlem 
çiftlerini yaratacağız ve deftere yazılan verileri kontrol edeceğiz.
İşleri basit tutmak için, Docker kullanacağız.

.. not:: Defter blokzincirin eşanlamlısıdır ve Hyperledger Iroha ayrıca
  Distributed Ledger Technology çalışma alanı olarak bilinir — esasen "blokzincir çalışma alanıyla" aynıdır.
  :ref:`core-concepts` bölümünde kullanılan terminolojinin kalanını kontrol edebilirsiniz.

Önkoşullar
----------
Bu kılavuz için, ``Docker`` kurulu bir makineye ihtiyaç duyarsınız.
`Docker'ın internet sitesinde <https://www.docker.com/community-edition/>`_ nasıl kurulacağını okuyabilirsiniz.

.. not:: Tabiki Iroha'yı sıfırdan yükleyebilirsiniz, kodunu değiştirebilir ve özelleştirilmiş bir düğüm başlatabilirsiniz!
  Eğer bunun nasıl yapıldığına dair meraklıysanız — :ref:`build-guide` bölümünü kontrol edebilirsiniz.
  Bu kılavuzda docket görüntüsü olarak Iroha'nın mevcut standart dağıtımını kullanacağız.

Iroha Düğümüne Başlamak
-----------------------

.. raw:: html

  <script id="asciicast-345137" src="https://asciinema.org/a/345137.js" async></script>

Bir Docker Ağı Yaratmak
^^^^^^^^^^^^^^^^^^^^^^^
Çalıştırmak için, Iroha bir ``PostgreSQL`` veritabanı gerektirir.
Bir Docker ağı yaratmakla başlayalım, böylece Postgres ve Iroha için 
konteynerler aynı sanal ağda çalışabilir ve başarılı bir şekilde iletişim kurabilir.
Bu kılavuzda ``iroha-network`` ismiyle bahsedeceğiz, fakat herhangi bir isim kullanabilirsiniz.
Terminalinizde aşağıdaki komutu yazınız:

.. code-block:: shell

  docker network create iroha-network

PostgreSQL Konteynerine Başlamak
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Şimdi bir konteynerde ``PostgreSQL`` çalıştırmaya ihtiyaç duyuyoruz, daha önce oluşturduğumuz 
ağa ekleyin, ve iletişim için bağlantı noktalarını açığa çıkarınız:

.. code-block:: shell

  docker run --name some-postgres \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -p 5432:5432 \
  --network=iroha-network \
  -d postgres:9.5 \
  -c 'max_prepared_transactions=100'

.. not:: Eğer varsayılan bağlantı noktasında (5432) bir ana bilgisayar sisteminde çalışan zaten Postgres'e sahipseniz,
  kullanılacak başka bir boş bağlantı noktası seçmelisiniz.
  Örneğin, 5433: ``-p 5433:5432``

Blok Deposu Yaratmak
^^^^^^^^^^^^^^^^^^^
Iroha konteynerini çalıştırmadan önce, dosyaları saklamak ve zincir için blokları saklamak için kalıcı bir volüm yaratabiliriz.
Aşağıdaki komutlar aracılığıyla yapılır:

.. code-block:: shell

  docker volume create blockstore

Konfigürasyon Dosyalarının Hazırlanması
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. not:: İşleri basit tutmak için, bu kılavuzda yalnızca tek bir düğüm içeren bir ağ yaratacağız.
  Birkaç eşin nasıl çalıştığını anlamak için, :ref:`deploy-guide`'ı takip edin

Şimdi Iroha ağımızı yapılandırmamız gerekiyor.
Bu bir konfigürasyon dosyası oluşturmayı, kullanıcılar için anahtar çifti oluşturmayı,
eşlerin listesini yazmayı ve bir genesis bloğu yaratmayı içerir.

Korkmayın — bu kılavuz için örnek bir konfigürasyon hazırladık,
böylece şimdi Iroha düğümünü test etmeye başlayabilirsiniz.
Bu dosyaları almak için, Github'dan `Iroha deposunu <https://github.com/hyperledger/iroha>`_ 
klonlamanız gerekiyor veya manuel olarak kopyalayabilirsiniz (klonlama daha hızlı).

.. code-block:: shell

  git clone -b master https://github.com/hyperledger/iroha --depth=1

.. ipucu:: ``--depth=1`` seçeneği yalnızca son işlemeyi indirmemize ve zamandan ve 
  bant genişliğinden tasarruf etmemizi sağlar. Eğer bütün işleme geçmişine erişmek isterseniz, 
  bu seçeneği atlayabilirsiniz.

Parametrelerin nasıl kurulacağı ve ortamınıza ve yük beklentinize göre nasıl 
ayarlanacağı hakkında bir kılavuz vardır: :ref:`configuration`.
Şu anda bunu yapmamız gerekmiyor.

Iroha Konteynerine Başlamak
^^^^^^^^^^^^^^^^^^^^^^^^^^^
Neredeyse Iroha konteynerimizi başlatmaya hazırız.
Sadece konfigürasyon dosyalarının yolunu bilmeniz gerekiyor (üstteki adımdan).

Aşağıdaki komutla Docker konteynerindeki Iroha düğümünü başlatın:

.. code-block:: shell

  docker run --name iroha \
  -d \
  -p 50051:50051 \
  -v $(pwd)/iroha/example:/opt/iroha_data \
  -v blockstore:/tmp/block_store \
  --network=iroha-network \
  -e KEY='node0' \
  hyperledger/iroha:latest

Eğer düğümü başarılı bir şekilde başlattıysanız konteyneri başlattığınız aynı konsolda konteyner id'sini görürsünüz.

Bu komutun ne yaptığına detaylı olarak bakalım:

- ``docker run --name iroha \`` bir ``iroha`` konteyneri yaratır 
- ``-d \`` arkaplanda konteyneri çalıştırır
- ``-p 50051:50051 \`` bir kullanıcı ile iletişim için bir bağlantı noktası ortaya çıkarır (bunu daha sonra kullanacağız)
- ``-v YOUR_PATH_TO_CONF_FILES:/opt/iroha_data \`` docker konteynerine konfigürasyon dosyalarımızı 
  nasıl ilettiğimizdir. Örnek dizin yukarıdaki kod bloğunda belirtildi.
- ``-v blockstore:/tmp/block_store \`` bir konteynere kalıcı blok depolama alanı (Docker volüm) ekler,
  böylece biz konteyneri durdurduktan sonra bloklar kaybolmaz 
- ``--network=iroha-network \`` PostgreSQL sunucusu ile iletişim için konteynerimizi daha önce 
  oluşturulmuş ``iroha-network``'a ekler
- ``-e KEY='node0' \`` - burada lütfen işlemlerin onaylanmasına izin veren düğümü tanımlayacak bir anahtar adı belirtin.
  Anahtarlar yukarıda bahsedilen konfigürasyon dosyalarıyla birlikte dizine yerleştirilmelidir.
- ``hyperledger/iroha:latest`` en son sürüme işaret eden görüntüye bir 
  `referanstır <https://github.com/hyperledger/iroha/releases>`__

``docker logs iroha`` çalıştırarak işlem geçmişini kontrol edebilirsiniz.

Bâzı işlemleri Iroha'ya göndermek ve durumunu sorgulamak için örnek kılavuzlardan birini kullanmayı deneyebilirsiniz.

Diğer kılavuzları deneyin
-------------------------

.. toctree::
      :maxdepth: 2

      cli-guide.rst
      python-guide.rst
