========
Shepherd
========

Shepherd, irohad arka plan programını çalıştıran bakım görevlerini yerine getirmeye yardımcı olan bir komut satırı yardımcı uygulamasıdır.

Önkoşullar
==========

irohad arka plan programına erişmek için, hizmet programı içinde yapılandırılmalıdır.
`Konfigürasyon detaylarına <#configuring-irohad>`_ bakınız.

Ardından, ``shepherd``'ı çağırırken, irohad hizmet programının adres ve bağlantı noktalarıyla ``--irohad`` komut satırı argümanını geçin:

.. code-block:: shell

   ./shepherd --irohad 127.0.0.1:11001 <...>

Desteklenen eylemler
====================

Bunlar ek komut satırı argümanları belirterek ``shepherd`` ile yapabileceğiniz şeylerdir.

Otomatik zararsız kapanma
^^^^^^^^^^^^^^^^^^^^^^^^^
İroha'yı daha önce nasıl durdurdunuz?
Ne yani, gerçekten prosesi durdurdunuz mu?
Lütfen bir daha asla yapma, kibar ve hoş değil!

.. code-block:: shell

   ./shepherd <...> --shutdown

``--shutdown`` argümanıyla, shepherd kibarca Iroha'dan durmasını isteyecek.

İşe yaradığını izleyin
^^^^^^^^^^^^^^^^^^^^^^
Yaygın olarak görülen en büyük zevklerden biri, başkalarının çalışmasını izlemektir.
Shepherd ile Iroha'nın çalışmasını izleyebilirsiniz!

.. code-block:: shell

   ./shepherd <...> --status

Bu, çalışma döngüsü durum güncellemelerine abone olacaktır.
Arka plan programı başlatılırken, çalışırken, sonlandırıldığında veya henüz durduğunda net mesajlar alacaksınız.

Diğer parametreler
==================

Ayrıca işlem geçmişi saklama seviyesini ayarlayabilirsiniz:

.. code-block:: shell

   ./shepherd <...> --verbosity debug <...>

Desteklenen değerler ``trace``, ``debug``, ``info``, ``warning``, ``error`` ve ``critical``'dır.
