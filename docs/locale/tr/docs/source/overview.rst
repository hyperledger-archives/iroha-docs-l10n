====================
Iroha'ya Genel Bakış
====================

Iroha'nın ana özellikleri nelerdir?
-----------------------------------

- Basit dağıtım ve bakım
- Geliştiriciler için çeşitli kütüphaneler
- Rol tabanlı erişim kontrolü
- Modüler dizayn, komut-sorgu ayırma ilkesi tarafından yönlendirilir
- Varlıklar ve kimlik yönetimi

Kalite modelimizde, odaklanırız ve sürekli geliştiririz:

- Güvenilirlik (hata toleransı, geri kazanılabilirlik)
- Performans Verimliliği (özellikle zaman-davranış ve kaynak kullanımı)
- Kullanılabilirlik (öğrenilebilirlik, kullanıcı hatası koruması, uygunluk tanınabilirliği)

Iroha nerede kullanılabilir?
----------------------------

Hyperledger Iroha, dijital varlıkları, kimliği ve serileştirilmiş verileri yönetmek için kullanılabilen genel amaçlı yetkilendirilmiş bir blokzincir sistemidir.

Bu, bankalar arası ödeme, merkez bankası dijital para birimleri, ödeme sistemleri, ulusal kimlikler ve lojistik gibi uygulamalar için kullanışlı olabilir.

Detaylı bir açıklama için lütfen `Kullanım Senaryoları bölümümüze <develop/cases.html>`_ göz atın.

Bitcoin veya Ethereum'dan farkı nedir?
--------------------------------------

Bitcoin ve Ethereum herhangi birinin tüm verilere katılabileceği ve tüm verilere erişebileceği izinsiz defterler olarak tasarlanmıştır.
Ayrıca, sistemlerle etkileşime girmesi gereken yerel kripto para birimlerine de sahiptirler.

Iroha'da  yerel kripto para birimleri yoktur. Bunun yerine, işletmelerin ihtiyaçlarını karşılamak için sistem etkileşimine izin verilir bunun anlamı yalnızca gerekli erişime sahip insanlar sistemle etkileşime girebilir. Ek olarak, tüm verilere erişimin kontrol edilebilmesi için sorgulara da izin verilir.


Özellikle Ethereum'dan önemli bir farkı, kullanıcıların sistemde önceden oluşturulmuş olan komutları kullanarak dijital varlıklar yaratması ve transfer etmesi gibi ortak fonksiyonları gerçekleştirmesine izin vermesidir.
Bu, zahmetli ve test edilmesi zor akıllı sözleşmeleri yazma ihtiyacını ortadan kaldırarak, geliştiricilerin basit görevleri daha hızlı ve daha az riskle tamamlamalarını sağlar.

Hyperledger çalışma alanının veya izin verilen diğer blokzincirlerinin geri kalanından farkı nedir?
---------------------------------------------------------------------------------------------------

Iroha, yüksek performanslı ve düşük gecikme süresine sahip işlemlerin sona ermesine izin veren Crash hata toleranslı konsensüs algoritmasına (YAC adı verilir) sahiptir.

Ayrıca, Iroha'nın yerleşik komutları diğer platformlarla karşılaştırıldığında büyük faydaları vardır çünkü dijital varlıklar yaratmak, hesap oluşturmak ve hesaplar arasında varlıkları transfer etmek gibi yaygın görevleri yapmak için çok basittir.
Dahası, atak vektörünü daraltır, başarısızlık için daha az şey olduğundan sistemin genel güvenliğini artırır.

Son olarak, Iroha, tüm komutlar, sorgular ve ağa katılma için izinlerin ayarlanmasına izin veren dayanıklı bir izin sistemine sahip tek defterdir.

.. [#f1] Bir Diğer Konsensüs

Iroha etrafında uygulamalar nasıl yaratılır?
--------------------------------------------

Blokzincirin gücünü uygulamanıza getirmek için, önce Iroha eşleriyle nasıl arayüz olacağını düşünmelisiniz.
İyi bir başlangıç bir işlemin ve sorgunun tam olarak ne olduğunu ve uygulamalarınızın kullanıcılarının onunla nasıl etkileşim kurması gerektiğini açıklayan `Kavramlar ve Mimari bölümünü <concepts_architecture/index.html>`_ kontrol etmektir.

Ayrıca, geliştiriciler için imzalar, komutlar, Iroha eşlerine mesaj atmak ve durumu kontol etmek gibi yapı taşlarından
 araçlar sağlayan birkaç kullanıcı kütüphanesine sahibiz.