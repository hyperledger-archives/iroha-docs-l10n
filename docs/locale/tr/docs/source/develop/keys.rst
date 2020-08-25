====================
Anahtar Çifti Biçimi
====================

Iroha işlemleri imzalamak için anahtar çiftleri kullanır (.pub ve .priv anahtarları) – her `hesap <../concepts_architecture/glossary.html#account>`_ en az 1 çifte sahiptir.
Bâzı hesaplar (eğer `yeterli çoğunluk <../concepts_architecture/glossary.html#quorum>`_ 1'den fazlaysa) daha fazla işlemleri imzalayan `İmza sahiplerine <../concepts_architecture/glossary.html#signatory>`_ sahip olabilir – ve her İmza sahibi bir anahtar çiftine sahiptir.
kriptografik algoritma bu anahtarları kullanır – ve Iroha'da size kullanılacak algoritmalarla alâkalı bir tercih sağlarız.

.. note:: Check out how to create key pairs using the Python library `here <../getting_started/python-guide.html#creating-your-own-key-pairs-with-python-library>`_.

Destekli Kripto Algoritmaları
=============================

Doğal olarak, HL Iroha özel bir algoritma kullanır – SHA-3 ile Ed25519.
Bu anahtarlar eskileri de içerecek şekilde Iroha'nın bütün versiyonları tarafından desteklenir.
Fakat hepimizin bildiği gibi, daha evrensel seçeneklere de ihtiyaç duyarız – bunun sebebi Iroha'nın `HL Ursa entegrasyonuna <../integrations/index.html#hyperledger-ursa>`_ sahip olmasıdır – daha ana akım anahtarlar kullanarak Iroha ile çalışmaya izin veren farklı kripto algoritmalara sahip bir kütüphanedir.
Ursa SHA-2 algoritması ile Ed25519 standart desteği ile Iroha sağlar.

Genel Anahtarlar
----------------

Kolay çözüm sağlamak için geriye dönük uyumluluk "kesilmeden" farklı algoritmalar kullanmasına izin verir, Iroha'daki genel anahtarlar için **çoklu karışım** biçimini tanıtacağız.
Çoklu karışım hakkında daha fazla bilgiyi `buradan <https://github.com/multiformats/multihash>`_ öğrenebilirsiniz.

Genellikle, yerli SHA-3 ed25519 anahtarlarından farklı anahtarları kullanmak için bu formata taşımanız gerekecek:

.. code-block:: shell

	<varint key type code><varint key size in bytes><actual key bytes>


.. not:: Çoklu karışımda varints En Anlamlı Bit imzasız varints'dir (ayrıca base-128 varints olarak adlandırılır).


Eğer Iroha 32 baytlık standart bir genel anahtar alırsa, yerel bir Iroha anahtarı olarak davranacaktır.
Eğer bir çoklu karışım genel anahtar alırsa, aşağıdaki tabloyu baz alarak davranacaktır.


Şimdi, Iroha yalnızca bir çoklu karışım anahtar biçimini "algılar":

+------------+-----------+----------+------------------+
|Adı         |Etiket     |Kod       |Açıklama          |
+============+===========+==========+==================+
|ed25519-pub |key        |0xed	    |Ed25519 public key|
+------------+-----------+----------+------------------+

Iroha'daki genel anahtarlara örnekler:

+----------------+--------+----------+-------------------------+----------------------+
| tip            | kod    | uzunluk  | veri                    | Iroha'nın tanıdığı   |
+================+========+==========+=========================+======================+
| multihash key  | ED01   | 20       | 62646464c35383430b...   | ed25519/sha2         |
+----------------+--------+----------+-------------------------+----------------------+
| raw 32 byte key| --     | --       | 716fe505f69f18511a...   | ed25519/sha3         |
+----------------+--------+----------+-------------------------+----------------------+

`0xED` kodu çoklu karışım biçiminin kuralı tarafından `ED01` olarak şifrelenmiş olduğunu dikkate alınız.

Özel Anahtarlar
---------------

Ursa'daki **özel anahtarlar** bir özel anahtar ve bir genel anahtarın birleştirilmesiyle temsil edilir – çoklu karışım ön eki olmaksızın.
