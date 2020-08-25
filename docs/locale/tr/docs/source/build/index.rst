.. _build-guide:

==============
Iroha Kurulumu
==============

Bu kılavuzda Iroha'nın kurulumu için gereken bütün bağımlılıkları nasıl kuracağımızı ve Iroha'nın nasıl kurulacağını öğreneceğiz.

Kurulum için 3 adım var:

#. Ortam önkoşulların kurulumu

#. Iroha bağımlılıklarının kurulumu (Docker için otomatik olarak uygulanacak)

#. Iroha'nın kurulumu

.. not:: Kullanmaya başlamak için Iroha'yı kurmanıza gerek yok.
  Bunun yerine, Hub'dan hazırlanmış Docker görüntüsünü indirebilirsiniz,
  bu süreç dökümanın :ref:`getting-started` sayfasında detaylıca açıklandı.

Önkoşullar
=============

Iroha'nın başarılı bir şekilde kurulumu için ortamın konfigüre edilmesine ihtiyaç duyarız.
Bunu yapmanın birkaç yolu var ve hepsini anlatacağız.

Şu anda Unix benzeri sistemleri destekliyoruz (temel olarak popüler Linux dağıtımlarını
ve MacOS'u hedefliyoruz). Windows'unuz varsa veya bütün bağımlılıkları yüklemek için 
zaman harcamak istemiyorsanız Docker ortamını kullanmayı düşünmeyi 
isteyebilirsiniz. Ayrıca, Windows kullanıcıları `WSL <https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux>`_
kullanmayı düşünebilir.


Teknik olarak Iroha Windows'un altında deneysel modda kurulabilir.
Bu kılavuz bu yöntemi de kapsamaktadır.
Yerel Windows kurulumu ile alakalı bütün aşamalar önemli farklılıklarından dolayı ana akıştan ayrılır.

Lütfen hızlı erişim için aşağıdaki tercih ettiğiniz platformu seçiniz:

    - :ref:`docker-pre`
    - :ref:`linux-pre`
    - :ref:`MacOS-pre`
    - :ref:`Windows-pre`


.. ipucu:: Sorun mu yaşıyorsunuz? Sıkça Sorulan Sorular bölümünü kontrol edin veya
  bir şeye takılmanız halinde doğrudan bizimle iletişime geçin. Bunun olmasını
  beklemiyoruz, fakat ortam ile ilgili bâzı sorunlar mümkündür.

.. _docker-pre:

Docker
^^^^^^

Öncelikle, ``docker`` ve ``docker-compose``'u yüklemeniz gerekli. 
`Docker'ın websitesinden <https://www.docker.com/community-edition/>`_ kurulumunu 
nasıl yapabileceğinizi okuyabilirsiniz.

.. not:: Lütfen, mevcut son çıkan docker daemon ve docker-compose'u kullanın.

Sonrasında `Iroha deposunu <https://github.com/hyperledger/iroha>`_ seçtiğiniz
dizine klonlamalısınız:

.. code-block:: shell

  git clone -b master https://github.com/hyperledger/iroha --depth=1

.. ipucu:: ``--depth=1`` seçeneği yalnızca son işlemeyi indirmemize izin verir 
  ve zaman ve bant genişliğinden tasarruf etmemizi sağlar. Eğer bütün işleme geçmişine
  erişmek istiyorsanız, bu seçeneği atlayabilirsiniz.

Tamamlandığında geliştirme ortamını çalıştırmanız gerekmektedir. Alttaki kod satırını çalıştırın:
``scripts/run-iroha-dev.sh`` betiği:

.. code-block:: shell

  bash scripts/run-iroha-dev.sh

.. ipucu:: Lütfen betik gerçekleştirilmeden önce Docker'ın çalışıyor olduğuna emin olun.
  MacOS kullanıcıları sistem çubuğunda bir Docker ikonu bulabilir, Linux kullanıcıları şunu kullanabilir:
  ``systemctl start docker``

Bu betiği gerçekleştirdikten sonra, aşağıdakiler gerçekleştirilecek:

#. Betik Iroha ile halihazırda çalışan konteynerlerin olup olmadığını kontrol eder. Yeni konteyner kabuğu ile başarılı bir şekilde tamamlanır.

#. Betik ``hyperledger/iroha:develop-build`` ve ``postgres`` görüntülerini yükler. ``hyperledger/iroha:develop-build`` görüntüsü bütün geliştirme bağımlılıklarını içerir ve ``ubuntu:18.04``'nun üstüne dayanmaktadır. ``postgres`` görüntüsü Iroha'nın başlaması ve çalışması için gereklidir.

#. İki konteyner yaratılır ve başlatılır.

#. Kullanıcı ana makineden ``iroha`` dosyası ile geliştirme ve test için interaktif ortama eklenir. Iroha dosyası Docker konteynerindeki ``/opt/iroha``'a bağlanır.

Şimdi Iroha kurulumuna hazırsınız! Lütfen doğrudan `Building Iroha <#build-process>`_ bölümüne gidin.

.. _linux-pre:

Linux
^^^^^

Iroha kurulumu için, alttaki paketlere ihtiyacınız var:

``build-essential`` ``git`` ``ca-certificates`` ``tar`` ``ninja-build`` ``curl`` ``unzip`` ``cmake``

Debian tabanlı Linux dağıtımında ortam bağımlılıklarını yüklemek için bu kodu kullanın.

.. code-block:: shell

  apt-get update; \
  apt-get -y --no-install-recommends install \
  build-essential ninja-build \
  git ca-certificates tar curl unzip cmake

.. not::  Eğer Iroha'yı aktif bir şekilde geliştirmeye ve paylaşılan kütüphaneler 
  oluşturmaya istekliyseniz, lütfen CMake'in `son sürümünü 
  <https://cmake.org/download/>`_ kurmayı düşünün.

Şimdi `Iroha'nın bağımlılıklarını kurmaya <#installing-dependencies-with-vcpkg-dependency-manager>`_ hazırsınız.

.. _macos-pre:

MacOS
^^^^^

Iroha'yı sıfırdan oluşturmak ve aktif bir şekilde geliştirmek istiyorsanız, lütfen Homebrew 
ile bütün ortam bağımlılıklarını yüklemek için aşağıdaki kodu kullanın:

.. code-block:: shell

  xcode-select --install
  brew install cmake ninja git gcc@7

.. ipucu:: Homebrew'i yüklemek için lütfen çalıştırın

  ``ruby -e "$(curl -fsSL https://raw.githubusercontent.com/homebrew/install/master/install)"``

Şimdi `Iroha'nın bağımlılıklarını kurmaya <#installing-dependencies-with-vcpkg-dependency-manager>`_ hazırsınız.

.. _windows-pre:

Windows
^^^^^^^

.. not:: Listenen bütün komutlar Iroha'nın 64 bit versiyonu oluşturmak için dizayn edilmiştir.

Chocolatey Package Manager
""""""""""""""""""""""""""

Öncelikle Chocolatey package manager'ı yüklemeniz gerekmektedir.
Lütfen chocolatey kurulumu için `kılavuza <https://chocolatey.org/install>`_ başvurun.

Building the Toolset
""""""""""""""""""""

Komut sistemi Yönetici modda olacak şekilde chocolatey aracılığıyla CMake, Git, Microsoft derleyicilerini kurun:

.. code-block:: shell

  choco install cmake git visualstudio2019-workload-vctools ninja


PostgreSQL bir yapı bağımlılığı değildir fakat sonra test etmek için şimdi yüklenmesi önerilir:

  .. code-block:: shell

    choco install postgresql
    # Belirlediğiniz şifreyi unutmayın!

Şimdi `Iroha'nın bağımlılıklarını kurmaya <#installing-dependencies-with-vcpkg-dependency-manager>`_ hazırsınız.

Installing dependencies with Vcpkg Dependency Manager
=====================================================

Şu anda bütün platformlar için bağımlılık yöneticisi olarak Vcpkg kullanıyoruz - Linux, Windows ve MacOS.
İhtiyacımız olan yamaların çalışmasını sağlamak için sabit bir Vcpkg versiyonu kullanıyoruz.

Bu sabit versiyon yalnızca Iroha deposunun içinde bulunabilir bu nedenle Iroha'yı klonlamamız gerekmektedir.
Tüm süreç bütün platformlar için oldukça benzerdir fakat kesin komutlar biraz farklıdır.

Linux and MacOS
^^^^^^^^^^^^^^^

Terminalde çalıştır:

.. code-block:: shell

  git clone https://github.com/hyperledger/iroha.git
  iroha/vcpkg/build_iroha_deps.sh
  vcpkg/vcpkg integrate install

Vcpkg kurulumundan sonra size alttaki gibi bir CMake build parameter verilecektir
``-DCMAKE_TOOLCHAIN_FILE=/path/to/vcpkg/scripts/buildsystems/vcpkg.cmake``.
Sonra kullanmak için bir yere kaydedin ve `Iroha'nın Oluşturulması <#build-process>`_ bölümüne gidin.

Windows
^^^^^^^

Power Shell'den gerçekleştir:

.. code-block:: shell

  git clone https://github.com/hyperledger/iroha.git
  powershell -ExecutionPolicy ByPass -File .\iroha\.packer\win\scripts\vcpkg.ps1 .\vcpkg .\iroha\vcpkg

Vcpkg kurulumundan sonra size alttaki gibi bir CMake build parameter verilecektir
``-DCMAKE_TOOLCHAIN_FILE=C:/path/to/vcpkg/scripts/buildsystems/vcpkg.cmake``.
Sonra kullanmak için bir yere kaydedin ve `Iroha'nın Oluşturulması <#build-process>`_ bölümüne gidin.

.. not:: Eğer Iroha'nın 32 bit versiyonunu oluşturmayı planlıyorsanız -
  üstte bahsedilen bütün kütüphaneleri öneki ``x64`` yerine 
  ``x86`` olarak yüklemeniz gerekmektedir.

Oluşturma Süreci
================

Depoyu klonlama
^^^^^^^^^^^^^^^^
Önceki adımda Iroha'yı klonladığımız için bu adım gereksizdir.
Fakat eğer isterseniz `Iroha deposunu <https://github.com/hyperledger/iroha>`_ to the
seçtiğiniz dizine klonlayabilirsiniz.

.. code-block:: shell

  git clone -b master https://github.com/hyperledger/iroha
  cd iroha

.. ipucu:: Eğer Docker ile önkoşulları yüklediyseniz, Iroha'nın klonuna 
  ihtiyaç duymayacaksınız, çünkü ``run-iroha-dev.sh``'ı çalıştırdığınızda Iroha 
  kaynak kodu klasörüne eklenir. Ana ortamınız ile kaynak kodu dosyalarını 
  düzenleyebilir ve docker container'ının içinde oluşturabilirsiniz.


Iroha'nın Oluşturulması
^^^^^^^^^^^^^^^^^^^^^^^

Iroha'yı oluşturmak için şu komutları kullanın:

.. code-block:: shell

  cmake -H. -Bbuild -DCMAKE_TOOLCHAIN_FILE=/path/to/vcpkg/scripts/buildsystems/vcpkg.cmake -G "Ninja"
  cmake --build build --target irohad -- -j<number of threads>

.. not:: Docker'da bir araç-zinciri dosyasına giden yol ``/opt/dependencies/scripts/buildsystems/vcpkg.cmake``. Diğer 
  ortamlarda lütfen önceki adımlarda kullandığınız yolu kullanın.

İş-dizisi sayısı platforma bağlı olarak farklı bir şekilde tanımlanacaktır:
- Linux'ta: ``nproc`` aracılığıyla.
- MacOS'ta: ``sysctl -n hw.ncpu`` ile.
- Windows'ta: ``echo %NUMBER_OF_PROCESSORS%`` kullan.

.. not:: Windows'ta oluştururken bunu Power Shell'den gerçekleştirmeyin. x64 yerel araç komut sistemini kullanmak daha iyi.

Şimdi Iroha oluşturuldu. İsterseniz, aşağıda açıklanan ek parametrelerle oluşturabilirsiniz.

CMake Parameters
^^^^^^^^^^^^^^^^

Platforma bağlı oluşturma dosyaları oluşturmak için CMake kullanıyoruz.
Son yapıyı konfigüre etmek için çok sayıda bayrak var.
Listelenen parametrelerin dışında CMake'in değişkenleri de faydalı olabilir.
Also as long as this page can be deprecated (or just not complete) Ayrıca bu sayfanın kullanımdan kaldırıldığı
(veya henüz tamamlanmadığı) takdirde ``cmake -L``, ``cmake-gui``, or ``ccmake`` aracılığıyla özel bayraklara göz atabilirsiniz.

.. ipucu::  Parametreleri CMake konfigürasyon aşamasında belirleyebilirsiniz
  (örneğin cmake -DTESTING=ON).

Ana Parametreler
""""""""""""""""

+----------------------------------+-----------------+------------+----------------------------------------------------------------------------------+
| Parametre                        | Olası değerler  | Varsayılan | Açıklama                                                                         |
+==================================+=================+============+==================================================================================+
| TEST YAPMAK                      |      AÇIK/      | AÇIK       | Testlerin oluşturulmasını etkinleştirir/devre dışı bırakır                       |
+----------------------------------+      KAPALI     +------------+----------------------------------------------------------------------------------+
| KIYASLAMA                        |                 | KAPALI     | GoogleBenchmarks kütüphanesinin oluşturulmasını etkinleştirir/devre dışı bırakır |
+----------------------------------+                 +------------+----------------------------------------------------------------------------------+
| KAPSAM                           |                 | KAPALI     | Kod kapsamı oluşturma için lcov ayarını etkinleştirir/devredışı bırakır          |
+----------------------------------+                 +------------+----------------------------------------------------------------------------------+
| LIBURSA_KULLANIMI                |                 | KAPALI     | Standart yerine HL Ursa kriptografisinin kullanılmasını sağlar                   |
+----------------------------------+                 +------------+----------------------------------------------------------------------------------+
| BURROW_KULLANIMI                 |                 | KAPALI     | HL Burrow EVM entegrasyonunu etkinleştirir                                       |
+----------------------------------+-----------------+------------+----------------------------------------------------------------------------------+

.. not:: Yapınız için HL Ursa kriptografi kullanmak istiyorsanız, lütfen diğer bağımlılıklara ek olarak `Rust <https://www.rust-lang.org/tools/install>`_ yükleyin. HL Ursa entegrasyonu hakkında daha fazla bilgi edinmek için `buraya <../integrations/index.html#hyperledger-ursa>`_ tıklayınız.

Packaging Specific Parameters
"""""""""""""""""""""""""""""

+-----------------------+-----------------+------------+----------------------------------------------------------------+
| Parametre             | Olası değerler  | Varsayılan | Description                                                    |
+=======================+=================+============+================================================================+
| PACKAGE_ZIP           |      AÇIK/      | KAPALI     | Zip paketlemeyi etkinleştirir veya devre dışı bırakır          |
+-----------------------+      KAPALI     +------------+----------------------------------------------------------------+
| PACKAGE_TGZ           |                 | KAPALI     | Tar.gz paketlemeyi etkinleştirir veya devre dışı bırakır       |
+-----------------------+                 +------------+----------------------------------------------------------------+
| PACKAGE_RPM           |                 | KAPALI     | rpm paketlemeyi etkinleştirir veya devre dışı bırakır          |
+-----------------------+                 +------------+----------------------------------------------------------------+
| PACKAGE_DEB           |                 | KAPALI     | deb paketlemeyi etkinleştirir veya devre dışı bırakır          |
+-----------------------+-----------------+------------+----------------------------------------------------------------+

Çalıştırma Testleri (isteğe bağlı)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Iroha oluşturulduktan sonra, daemon'un çalışabilirliğini test etmek 
için çalıştırma testi yapmak iyi bir fikir. Bu kod ile testi çalıştırabilirsiniz:

.. code-block:: shell

  cmake --build build --target test

Alternatif olarak, ``build`` dosyası içinde aşağıdaki komutlar ile çalıştırabilirsiniz.

.. code-block:: shell

  cd build
  ctest . --output-on-failure

.. not:: Teslerin bâzıları PostgreSQL depolaması çalışmadan başarısız olur,
  bu nedenle eğer ``scripts/run-iroha-dev.sh`` betiği kullanmıyorsan lütfen Docker'ı çalıştırın
  container veya aşağıdaki parametrelerle yerel bir bağlantı oluşturabilirsiniz:

  .. code-block:: shell

    docker run --name some-postgres \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=mysecretpassword \
    -p 5432:5432 \
    -d postgres:9.5 \
    -c 'max_prepared_transactions=100'
