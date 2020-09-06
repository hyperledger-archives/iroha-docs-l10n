HL Burrow Entegrasyonu
======================

Iroha bakımcıları olarak, kullanıcılarımızdan özel akıllı-sözleşme desteği için birçok soru ve istek aldık.
Ve iş ihtiyaçlarını karşılamada daha fazla özgürlük sağlamak için, HL Burrow EVM entegre ettik – Hyperledger greenhouse'un başka harika projesi, – Iroha'da.

.. not:: Iroha'nın içeriğinde, HL Burrow Solidity akıllı-sözleşmelerini çalıştırabilecek bir Ethereum Sanal Makinesi sağlar.
	Size mümkün olan en iyi kullanıcı deneyimini sağlamak için elimizden gelenin en iyisini yaptık – ve Iroha ile kullanmak için, sadece  `CMake flag during Iroha build <../build/index.html#cmake-parameters>`_ eklemeniz gerekir ve hemen çalışmaya başlayacak.

Eğer bu dilde yeniyseniz, Solidity akıllı sözleşme dili hakkında `buradan <https://solidity.readthedocs.io/>`_ bilgi edinebilirsiniz.

Nasıl çalışır
-------------

Bu entegrasyon için, Iroha'da özel bir `Çağrı Motoru komutu <../develop/api/commands.html#call-engine>`_ yarattık, bununla birlikte komutların sonuçlarını almak için özel bir `Motor Alındı sorgusu <../develop/api/queries.html#engine-receipts>`_ yarattık.

Komut
^^^^^

Komutta şunları yapabilirsiniz:

**Сreate a new contract account in EVM**

Eğer `CallEngine <../develop/api/commands.html#call-engine>`_'deki *callee* belirtilmediyse ve *input* parametresi bâzı bayt kodları içeriyorsa, yeni bir sözleşme hesabı oluşturulur.

**Call a method of a previously deployed contract**

Eğer the *callee* belirtilmediyse, girdi callee sözleşmesinin metodunun ardından argümanların ABI-kodlu bir seçici olarak kabul edilir.

.. ipucu:: `eth_sendTransaction <https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sendtransaction>`_ mesaj çağrısının `veri` alanının içeriğine bağlı olarak Ethereum'da bir sözleşme yapmak veya bir sözleşme fonksiyonu çağırmak gibidir.
	Detaylar için `ABI-specification <https://solidity.readthedocs.io/en/v0.6.5/abi-spec.html>`_ bakınız.

Sorgu
^^^^^

`CallEngine <../develop/api/commands.html#call-engine>`_ komutunun çıktısını sorgulamak için birisi `Motor Alındı sorgusunu <../develop/api/queries.html#engine-receipts>`_ kullanmalıdır.

EVM içindeki hesaplamaların çıktısı deftere yazılana kadar arayan için mevcut olmayacak (yani ilgili Iroha işlemine sahip blok işlenir).
Diğer `veriler <../develop/api/queries.html#response-structure>`_ arasında, *EngineReceipts* sorgusu *CallEngine* uygulaması boyunca EVM içinde oluşturulmuş bir işlem geçmişi girişleri dizisi döndürecek.

.. ipucu:: dApps geliştiricilerinin ilgili tarafların bir sözleşme yürütmesinin sonucunu görmelerine izin vermelerinin yaygın bir yolu, bir sözleşme metodundan çıkmadan önce bâzı veriler içeren bir olay yayınlamaktır böylece bu veriler *Event Log*'a yazılır.
	`Ethereum Yellow Paper <https://ethereum.github.io/yellowpaper/paper.pdf>`_ işlem geçmişi girdisini emitörün adresini, 32 bayt uzunluğunda konuların dizisini ve bâzı verilerin bayt dizisini içeren 3-veri grubu olarak tanımlar.

EVM'de Yerel Iroha Komutlarını Çalıştırma
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

HL Burrow Entegrasyonuyla, ayrıca Iroha'nın durumunu değiştirmek için yerel komutlar kullanabilirsiniz.

Burrow EVM entegrasyon mekanizması Iroha uygulama geliştiricilerine akıllı sözleşmeler kodundan Iroha durumunda doğrudan hareket edebilen bir araç sunar böylece yerleşik Iroha komut sisteminin programlanabilir iş mantığı uzantıları için dayanak sağlar.
Koşullu varlık transferleri, işlem ücretleri, değişimi mümkün olmayan varlıklar ve benzeri bu tür uzantılara sadece birkaç örnektir.
Buradaki aldatıcı bölüm Iroha veri modelinin Ethereum'dan oldukça farklı olmasıdır.
Örneğin, Ethereum'da sadece bir tür yerleşik varlık vardır (`Eth`) böylece EVM içeriğinde bir hesap bakiyesi elde etmek basitçe hesabın bakiye mülkünü geri döndürmek anlamına gelir.
Iroha'da tam tersine bir hesap birden fazla varlığa sahip olabilir veya hiç varlığı olmayabilir, böylece hesap bakiyesini geri döndüren herhangi bir fonksiyon en az bir ekstra argüman almalı – varlık ID'si.
Aynı mantık varlıkların hesaptan hesaba transfer edilmesi/gönderilmesi için de geçerlidir.

Bu veri modeli uyumsuzluğu problemine bir çözüm olarak, Iroha veri modelini “farkında” olan ve Iroha durumuyla etkileşime geçmek için bir API gösteren Hizmet Sözleşmelerini sunuyoruz (sorgu bakiyeleri, varlıkları aktarmak ve benzeri).

.. not:: Yerel ve harici görev dağıtıcılar hakkında daha fazla bilgi için `Burrow dökmantasyonunu <https://wiki.hyperledger.org/display/burrow/Burrow+-+The+Boring+Blockchain>`_ kontrol edebilirsiniz.

Sistemin farklı bölümleri arasındaki etkileşim şematik olarak şu şekildedir:

.. image:: ../../image_assets/burrow/natives.svg

.. dikkat::
	Burrow EVM perspektifinden bu tip Hizmet Sözleşmesi Yerli bir harici VM içinde barındırılıyor ve EVM'in kendisinde özel bir adrese konuşlandırılmış gibi aynı arayüzler aracılığıyla çağrılabilir.
	Bu metodlar spesifik olarak Iroha entegrasyonu için kullanılır, böylece Hizmet Sözleşmesinin adresi yalnızca Iroha ile çalışırken bulunabilir.

 Iroha EVM kapsayıcı mevcut sürümü hesaplar arasındaki Iroha varlık bakiyeleri ve varlıkları transfer etmeyi sorgulamak için 2 metod sunan `A6ABC17819738299B3B2C1CE46D55C74F04E290C` adresinde barındırılan tek bir hizmet sözleşmesi içerir (*ServiceContract* dizesinin *keccak256* karışımının son 20 baytı).

Bu iki metodun imzası şöyle görünür:

	**function** getAssetBalance(string memory *accountID*, string memory *assetID*) public view
	returns (string memory *result*) {}

	**function** transferAsset(string memory *src*, string memory *dst*, string memory *assetID*,
	string memory *amount*) public view returns (string memory *result*) {}

.. ipucu:: Geliştiricilerin perspektifinden yerel bir sözleşmenin fonksiyonunu çağırmak ikincisinin adresi biliniyorsa, başka bir akıllı sözleşmenin metodu çağırmaktan farklı değildir:

	bytes memory payload = abi.encodeWithSignature("getAssetBalance(string,string)", "myacc@test", "coin#test");

	(bool success, bytes memory ret) = address(0xA6ABC17819738299B3B2C1CE46D55C74F04E290C).delegatecall(payload);

Burada EVM mesaj çağrılarının özel bir türü kullanılır - bir sözleşmenin dinamik olarak yüklenmesine ve kendi yürütme içeriğinde işlem esnasında farklı bir adresten kod çalışmasına izin veren **delegatecall**.

.. ayrıcabakınız:: Şimdi, kullanım `örneklerine <burrow_example.html>`_ geçelim









