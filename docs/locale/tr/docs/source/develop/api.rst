Iroha API referansı
===================

API bölümünde Iroha ile etkileşim halindeki bir uygulamanın yapı taşlarına bir göz atacağız.
Sistemin sahip olduğu komutları ve sorguları ve taşıma ve uygulama katmanı mantığını kapsayan kullanıcı kütüphanesi kümesini gözden geçireceğiz.

Iroha API komut-sorgu ayırma `ilkesini <https://en.wikipedia.org/wiki/Command%E2%80%93query_separation>`_ takip eder.

Iroha eşi ve bir kullanıcı uygulaması arasındaki iletişim `gRPC <https://grpc.io/about/>`_ çalışma alanı aracılığıyla korunur. 
Kullanıcı uygulaması tanımlanmış protokolü ve `açıklamalarına <../concepts_architecture/glossary.html#transaction>`_ göre form işlemlerini takip etmelidir.


.. toctree::
    :maxdepth: 2
    :caption: Table of contents

    api/commands.rst
    api/queries.rst
    api/permissions.rst

Komutlar burada `işlemlerin <../concepts_architecture/glossary.html#transaction>`_ parçasıdır - sistemdeki durum-değiştiren eylemlerin kümesi. Bir işlem onaylama ve konsensüs aşamalarını geçerken, bir `bloğa <../concepts_architecture/glossary.html#block>`_ yazılır ve sabit blok depo alanına kaydedilir (blokzinciri).

İşlemler sistemde bir `varlık <../concepts_architecture/er_model.html>`_ üzerinde eylem gerçekleştiren komutlardan oluşur. Varlık bir hesap, varlık, vb. olabilir



