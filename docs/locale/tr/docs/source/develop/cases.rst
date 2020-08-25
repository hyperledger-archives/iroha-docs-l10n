Kullanım Senaryoları
====================

Kullanım durumlarının sayısını ve Hyperledger Iroha'nın bu uygulamalara getirebileceği spesifik avantajları listeleyeceğiz. Umuyoruz ki uygulamalar ve kullanım durumları Hyperledger Iroha ile geliştiricilere ve yaratıcılara daha fazla yenilik getirecek.  


Eğitim ve Sağlık Sertifikaları 
------------------------------ 

Hyperledger Iroha sisteme üniversiteler, okullar ve tıp kurumları gibi birçok sertifika yetkilisini dahil eder. Esnek yetki modeli sertifika kimliklerinin oluşturulmasına ve sertifika verilmesine izin veren Hyperledger Iroha'da kullanılır. Kullanıcıların hesabında belirgin ve belirgin olmayan bilgilerin depolanması çeşitli saygınlık ve kimlik sistemlerinin oluşturulmasına izin verir. 

Hyperledger Iroha kullanarak belirli sertifika yetkilileri tarafından verilen her eğitim veya tıp sertifikası doğrulanabilir. Değişmezlik ve net onaylama kuralları sahte sertifikaların kullanımını önemli ölçüde azaltan sağlık ve eğitime şeffaflık sağlar.

Örnek
^^^^^

Hyperledger Iroha'da ``hospital`` alanı olarak kayıtlı bir sağlık kurumunu düşünün. Bu alan her birinin sahip olduğu bir rolü olan sertifikalı ve kayıtlı çalışlanlara sahiptir, örneğin ``physician``, ``therapist``, ``nurse``. Hastanenin her hastası tam tıbbi geçmişle bir hesaba sahiptir. Kan testi sonuçları gibi her tıbbi kayıt JSON anahtar/değerler olarak hastanın hesabında güvenli ve özel bir şekilde depolanır. ``hospital`` alanında kurallar sadece sertifikalı tıbbi çalışanlar ve kişisel bilgilere erişebilen kullanıcılara tanımlanır. Tıbbi veri güvenilir bir kaynaktan gelen doğrulanmış bir sorgu tarafından geri döndürülür. 

Hastane yalnızca belirli bir bölgede vatandaşların kişisel bilgilerini saklamak gibi o lokasyonun yasal kurallarına uymak üzere spesifik bir lokasyona bağlıdır(`gizlilik kuralları`_). Hyperledger Iroha'daki çok-alanlı yaklaşım yasal kuralları ihlal etmeyen birçok ülkede bilgi paylaşımına izin verir. Örneğin, eğer ``makoto@hospital`` kullanıcısı kişisel durum geçmişini başka ülkedeki tıp kurumuyla paylaşmaya karar verirse, kullanıcı ``can_get_my_acc_detail`` yetkisiyle ``grant`` komutunu kulanabilir. 

Bir tıp kurumuna benzer şekilde, Hyperledger Iroha'da kayıtlı bir üniversite mezun öğrencilere bilgi vermek için yetkilere sahiptir. Bir diploma veya sertifika temelde tanınan Üniversitenin bir imzası ile Mezuniyetin-Kanıtıdır. Bu yaklaşım bir işverenin potansiyel elemanının kazanılmış becerilerini ve yeterliliğini elde etmek için Hyperledger Iroha'ya sorgulama yapmasıyla işe alım sürecinde kolaylaşmaya yardımcı olur. 

.. _`gizlilik kuralları`: https://privacypolicies.com/blog/privacy-law-by-country/

Sınır-Ötesi Varlık Transferleri
-------------------------------

Hyperledger Iroha çoklu imzalı hesapları ve atomik değişimi kullanarak hızlı ve net ticaret ve yerleşim kuralları sağlar. Varlık yönetimi gerekli güvenlik garantilerini sağlarken merkezi sistemlerdeki kadar kolaydır. Varlık yaratmak ve transfer etmek için gereken kuralları ve komutları basitleştirerek aynı zamanda yüksek-güvenlikli garantileri korurken giriş engelini indiriyoruz.  

Örnek
^^^^^

Örneğin [#f1]_, bir kullanıcı bir arabanın mülkiyetini transfer etmek isteyebilir. ``haruto`` kullanıcısı bu parametrelerle ``sora`` markalı bir araba ile sahip-varlık ilişkisine kayıt oldu: ``{"id": "34322069732074686520616E73776572", "color": "red", "size": "small"}``. Bu sahiplik her onaylayıcı eşteki kopyaları ile sistemin temel veritabanında sabitlenir. Transfer işlemi gerçekleştirmek için ``haruto`` kullanıcısı bir teklif oluşturur, örneğin iki komutlu çoklu-imza işlemi: ``haru`` kullanıcısına araba tanımlayıcısı ``transfer`` etmek ve ``haru``'dan ``haruto``'ya bir miktar ``usd`` jetonu ``transfer`` etmek. Teklifi alması üzerine ``haru`` çoklu-imza işlemini imzalayarak kabul eder, bu durumda işlem atomik olarak sisteme işlenir.  

Hypeledger Iroha dahili jetona sahip değildir fakat çeşitli yaratıcılardan farklı varlıkları destekler. Bu yaklaşım merkezi olmayan bir borsa oluşturulmasına izin verir. Örneğin, sistem farklı ülkelerden varlık ihraç etmek için merkez bankalarına sahip olabilir.

.. [#f1] Şu anda uygulanmadı  

Finansal Uygulamalar 
--------------------

Hyperleger Iroha denetim sürecinde çok kullanışlı olabilir. Her bilgi iş kuralları tarafından onaylanır ve farklı ağ katılımcıları tarafından sürekli korunur. Bâzı şifreleme ile birlikte erişim kontrol kuralları istenen gizlilik seviyesini korur. Erişim kontrol kuralları farklı seviyelerde tanımlanabilir: kullanıcı-seviyesi, alan-seviyesi veya sistem-seviyesi. Kullanıcı-seviyesinde spesifik bir birey için gizlilik kuralları tanımlanır. Eğer erişim kuralları alan veya sistem seviyesinde belirlenirse, alandaki bütün kullanıcıları etkiliyorlar. Hyperledger Iroha'da her rolün spesifik yetkilere sahip olduğu uygun rol-bazlı erişim kontrol kuralları sağlıyoruz. 

İşlemler yerel bir veritabanıyla izlenebilir. Iroha-API denetçisini kullanmak verileri sorgulayabilir ve analiz edebilir spesifik denetim yazılımları yürütebilir. Hyperledger Iroha analitik yazılımı dağıtmak için farklı senaryolara destek verir:  yerel bir bilgisayarda veya spesifik bir ara katmanda kodu çalıştırınız. Bu yaklaşım Hadoop, Apache ve diğerleriyle Big Data uygulamasını analiz etmeye izin verir. Hypeledger Iroha veri bütünlüğü ve gizliliğinin garantörü olarak servis yapar (sorgu yetkileri kısıtlaması nedeniyle). 

Örnek
^^^^^

Örneğin, denetleme finansal uygulamalarda yardımcı olabilir. Bir denetçi hesabı kullanıcıyı rahatsız etmeksizin alandaki kullanıcıların bilgisine erişim izni olan bir ``auditor`` rolüne sahiptir. Hesap ele geçirme ihtimalini azaltmak ve denetçinin kötü niyetli sorgular göndermesine engel olmak için, denetçi tipik olarak çoklu-imza hesabı olarak tanımlanır bunun anlamı denetçi yalnızca birden çok ayrı kimlikten imzalara sahip sorgular oluşturablir. Denetçi sadece hesap verilerini ve bakiyeyi almak için değil aynı zamanda bir kullanıcının bütün işlemlerini de sorgulayabilir, örneğin ``haruto`` kullanıcısının ``konoha`` alanındaki bütün transferleri. Milyonlarca kullanıcının verisini verimli bir biçimde analiz etmek için her Iroha düğümü analitik yazılımla beraber çalışabilir.    

Çoklu-imza işlemleri Hyperledger Iroha'nın vergi sistemini bozabilen güçlü bir aracıdır. Belirli bir alandaki her işlem ilk imzanın kullanıcıdan gelen (örneğin varlık transferi) ve ikinci imzanın özel vergi düğümlerinden gelen bir çoklu-imza işlemi olabilir. Vergi düğümleri Iroha-API kullanrak yazılmış özel onaylama kurallarına sahip olacaktır, örneğin sertifikalı mağazalardaki her sipariş vergi ödemek zorundadır. Başka bir deyişle, Iroha geçerli bir sipariş işlemi iki komut içermelidir: mağazaya para transferi(sipariş) ve devlete para transferi(vergi ödemesi).           


Kimlik Yönetimi
---------------

Hyperledger Iroha kimlik yönetimi için gerçek bir desteğe sahiptir. Sistemdeki her kullanıcı kişisel bilgilerinin bulunduğu özgün bir şekilde tanımlanmış bir hesaba sahiptir ve her işlem belirli bir kullanıcı tarafından imzalandı ve ilişkilendirildi. Bu KYC (Know Your Customer) özellikli çeşitli uygulamalar için Hyperledger Iroha'ı mükemmel yapar. 

Örnek
^^^^^

Örneğin, sigorta şirketleri bilginin doğruluğu hakkında endişe etmeksizin kullanıcının işlem bilgisinin sorgulanmasından faydalanabilir. Kullanıcılar ayrıca kişisel bilgilerin bir blokzincirinde depolanmasından da yararlanabilir çünkü kimliği doğrulanmış bilgiler taleplerin işleme koyulma süresini azaltacaktır. 
Peşin para kredisi almak isteyen bir kullanıcının olduğu bir durum düşünün. Şu anda, önyeterlilik gelir, borçlar ve bilgi doğrulaması hakkında bilgi toplamanın sıkıcı bir sürecidir. Hyperledger Iroha'daki her kullanıcı varlıklara sahip olmak, iş pozisyonları ve borçlar gibi doğrulanmış kişisel bilgilere sahip bir hesabı vardır. ``GetAccountTransactions`` kullanarak kullanıcının geliri ve borçları, ``GetAccountAssets`` sorgusunu kullanarak varlıkları ve ``GetAccountDetail`` kulanarak iş pozisyonları izlenilebilir. Her sorgu nakit para kredisinin işlem süresini azaltan doğrulanmış sonuç döndürür ve sadece birkaç saniye sürer.          
Kişisel bilgileri paylaşmaya kullanıcıları ikna etmek için, çeşitli şirketler iş süreçleriyle birlikte gelebilirler. Örneğin, sigorta şirketleri fitness aktiviteleri yapan kullanıcılar için bonus indirimler yapabilirler. Fitness uygulamaları özel Faaliyet-Kanıtı'nı sisteme gönderebilir ve kullanıcı ``can_get_my_acc_detail`` yetkisiyle ``GrantPermission`` kullanarak daha sonra sigorta şirketleriyle bilgi paylaşmaya karar verebilir.   


Tedarik Zinciri
---------------

Merkezi olmayan bir sistemin yöneimi ve sistemin bir kodu olarak yasal kuralların temsiliyeti herhangi bir tedarik zincir sisteminin temel bir kombinasyonudur. Hyperledger Iroha'da kullanılan Sertifikasyon sistemi fiziksel ürünlerin tokenizasyonuna ve onları sisteme gömmeye izin verir. Her ürün “ne, ne zaman, nerede ve neden” hakkında bilgilerle gelir. 

Yetki sistemleri ve kısıtlı güvenli çekirdek komutları kümesi atak vektörünü daraltır ve çaba harcamadan temel seviyede gizlilik sağlar. Her işlem karışım değerine sahip bir sistemde yaratıcının kimlik bilgileri veya sertifikaları tarafından izlenebilir. 

Örnek
^^^^^

Gıda tedarik zinciri çiftçiler, ambarlar, bakkallar ve müşteriler gibi birden fazla farklı aktöre sahip paylaşılan bir sistemdir. Amaç bir çiftçinin tarlasından bir müşterinin masasına yiyecek teslim etmektir. Ürün birçok aşamadan geçer ve her aşama paylaşılan alanda kaydedilir. Müşteri Iroha sorgusunun kodlandığı bir mobil cihaz aracılığıyla ürünün kodunu tarar. Iroha sorgusu bütün aşamalarıyla ürün ve çiftçi hakkındaki bilgilerle dolu bir geçmiş sağlar. 

Örneğin, ``gangreen`` kayıtlı bir çiftçi ``tomato`` varlık yaratıcısıdır, fiziksel eşyaları tokenleyen bir garantör olarak hizmet verir, örneğin her domatesin bir Iroha ``tomato`` ürünüyle ilişkilendirilmesi. Varlık yaratıcısı ve dağıtım süreçleri ağ katılımcıları için bütün olarak şeffaftır. Iroha ``tomato`` sonunda ``chad`` kullanıcısına gelmek için çok sayıda satıcı aracılığıyla bir yolculuğa çıkar. 

Varlık yaratmayı kompleks akıllı sözleşmeler oluşturmaya ihtiyaç duymadan yalnızca tek bir ``CreateAsset`` komutuyla basitleştirdik. Hyperledger Iroha'nın en büyük avantajlarından biri geliştiricilerin uygulamalarının sağlanan değerine odaklanmalarını kolaylaştırır. 

Fon Yönetimi
------------

Çoklu imza işlemlerinin desteği ile birçok yönetici tarafından fon sağlanması mümkündür. Bu şemada sadece yeterli sayıdaki katılımcıların onayından sonra yatırım yapılabilir.

Örnek
^^^^^^^

Fon varlıkları tek hesapta tutulmalıdır.
İmza sahipleri yatırımlar ve portföy dağıtımlarıyla ilgilenen fon yöneticileri olmalıdır.
``AddSignatory`` komutu aracılığıyla eklenebilir.
Tüm varlıklar imzalayanların fon yöneticilerini temsil ettiği tek bir hesapta tutulmalıdır.
Böylece somut değiş tokuşlar çok imzalı işlemlerle gerçekleştirilebilir böylece herkes belirli bir finansal karara karar verebilir.
Orjinal işlemi ve yöneticilerin birinin imzasını göndererek bir anlaşma onaylanabilir.
Iroha işlem gönderimini işlem çekirdeği parametresiyle parametreleştirilen gerekli sayıda onay alana kadar tamamlanmayacak şekilde sürdürür.


İlgili Araştırma
----------------

(Fikir blokzincir uygulamalarının ve çalışmalarının öncülerini göstermekti.)
