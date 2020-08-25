Öncelikle zamanınızı destek vermeye ayırdığınız için teşekkürler!

Aşağıda Iroha'ya nasıl destek verebileceğinizi anlatan bir kılavuz hazırladık.


#### İçindekiler

##### [Nasıl destek olabilirim?](#nasil-destek-olabilirim)

- [Hataları Raporlamak](#hatalari-raporlamak)
- [Güvenlik Açıklarını Raporlamak](#guvenlik-aciklarini-raporlamak)
- [İyileştirmeler Önermek](#iyilestirmeler-onermek)
- [Sorular Sormak](#sorular-sormak)
- [İlk Kod Desteğiniz](#ilk-kod-desteginiz)
- [Pull Talepleri](#pull-talepleri)

##### [Stil kılavuzları](#stil-kilavuzlari)

- [Git Stil Kılavuzu](#git-stil-kilavuzu)
- [C++ Stil Kılavuzu](#c-stil-kilavuzu)
- [Dokümantasyon Stil Kılavuzu](#dokumentasyon-stilkilavuzu)

### [Geliştiriciler ile Teamasa Geçin](#toplulugun-aktif-oldugu-yerler)


## Nasil Destek Olabilirim?

### Hatalari Raporlamak

Hatalar (bug) tasarım açıkları, yanlışlık ya da arıza olarak Iroha'nın geçersiz veya beklenmeyen bir sonuç üretmesine neden olan veya kasıt edilmemiş şekillerden davranmasına neden olan durumlardır.

Hatalar [JIRA sorunları](https://jira.hyperledger.org/projects/IR/issues/IR-275?filter=allopenissues&orderby=issuetype+ASC%2C+priority+DESC%2C+updated+DESC) olarak Hyperledger Jira'da tutulmaktadırlar..

Bir hatayı bildirmek istiyorsanız, [yeni bir sorun oluşturabilir](https://jira.hyperledger.org/secure/CreateIssue.jspa) ve aşağıdaki detayları girebilirsiniz:

| Alan                    | Giriş yapabileceğiniz                                            |
| :---------------------- | ---------------------------------------------------------------- |
| Proje                   | Iroha (IR)                                                       |
| Hata Tipi               | Bug                                                              |
| Özet                    | Sorunun esası                                                    |
| Açıklama                | Sorunun ne ile alakalı olduğu; eğer log (geçmiş) kayıtları varsa lütfen iletin|
| Öncelik                 | Orta (Medium) olarak girebilirsiniz ancak sorunun acil olduğunu düşünüyorsanız lütfen daha yüksek bir öncelik belirtiniz|
| Ortam                   | İşletim sisteminiz, cihazınızın özellikleri, Sanal Ortam (eğer kullanıyorsanız), Iroha'nın versiyonu vs.|


### Guvenlik Aciklarini Raporlamak

Güvenlik sorunları karşısında her ne kadar proaktif olmaya çalışsak da hiç çıkmayacaklarını telâkki etmiyoruz.

Sorumluluk bilinci gözeterek duyuru yapmadan önce gizlice güvenlik açığını üretici ile paylaşmak (Hyperledger organizasyonu), bir çözümün üretilmesine olanak tanımak ve güvenlik açığından doğacak zararları minimize etmek standartlaşmış bir pratiktir.

İlk Majör Sürüm'den önce (1.0) tespit edilen bütün güvenlik açıkları hata olarak değerlendirilmektedir, yukarıda anlatıldığı gibi bildirebilirsiniz.
İlk Majör Sürüm'den sonra ise lütfen [burada bir hata ödül programı](https://hackerone.com/hyperledger) oluşturup, güvenlik açığına karşılık ödülünüzü alabilirsiniz.


Her durumda da Rocket.Chat özel mesajlarından ya da e-posta (CONTRIBUTORS.md dosyasına bakın) yolu ile bakım personeli (maintainers) ile iletişime geçip keşfettiğinizin bir hata mı bir güvenlik açığımı olduğunu değerlendirebilirsiniz.

### Iyilestirmeler Onermek

Bir *iyileştirme* (improvement) **var olan** kodu ya da tasarımı daha hızlı, daha sağlam, taşınabilir, güvenli ya da başka bir yolla daha iyi yapan bir kod veya fikir olabilir.

İyileştirmeler [JIRA iyileştirmeleri](https://jira.hyperledger.org/browse/IR-184?jql=project%20%3D%20IR%20and%20issuetype%20%3D%20Improvement%20ORDER%20BY%20updated%20DESC) olarak takip edilmektedirler. Yeni bir iyileştirme göndermek istiyorsanız, [yeni iyileştirme oluşturup](https://jira.hyperledger.org/secure/CreateIssue.jspa) şu detayları ekleyebilirsiniz:

| Alan                    | Giriş yapabileceğiniz                                            |
| :---------------------- | ---------------------------------------------------------------- |
| Proje                   | Iroha (IR)                                                       |
| Hata Tipi               | İyileştirme (Improvement)                                        |
| Özet                    | Fikirin temelleri                                                |
| Açıklama                | Fikir ne ile alakalı; eğer kod önerileriniz varsa buraya ekleyebilirsiniz |
| Öncelik                 | Orta (Medium) olarak girebilirsiniz                              |
| Atama                   | Eğer üzerinde çalışmayı düşünüyorsanız kendinize atayabilirsiniz |

### Sorular Sormak

Bir *soru* hata, özellik talebi ya da iyileştirme olmayan herhangi bir görüşme olarak ele alınmaktadır. Eğer "X'i nasıl yaparım" gibi bir sorunuz varsa, bu paragraf sizin için.

Lütfen sorularınızı [favori mesajlaşma uygulamanızı kullanarak](#toplulugun-aktif-oldugu-yerler) iletiniz ki topluluk üyeleri size yardımcı olabilsinler.Aynı zamanda siz de başkalarına yardımcı olabilirsiniz.

### İlk Kod Desteğiniz

Lütfen bizim [C++ Stil Kılavuzu](#c-stil-kilavuzu)'muzu okuyup yeni başlayanlara uygun sorunlar -JIRA etiketi [`[good-first-issue]`](https://jira.hyperledger.org/issues/?jql=project%20%3D%20IR%20and%20labels%20%3D%20good-first-issue%20ORDER%20BY%20updated%20DESC) - üzerinde çalışmaya başlayarak yola koyulunuz. Ancak bir şekilde de ilgili sorun üzerinde çalıştığınızı ya bakım takımı ya da topluluk ile iletişime geçerek ya da ilgili sorunu kendinize atayarak bildiriniz.

### Pull Talepleri

- [Gerekli şablonu](.github/PULL_REQUEST_TEMPLATE.md) doldurunuz.

- Bütün dosya sonlarında bir boş satır bırakınız.

- Yeni kod için **testler yazınız**. Testler yazılmış kodun en az %70'ini kapsamalıdır.

- Her pull talebi gözden geçirilmeli ve **bakım takımından en az iki onay almalıdır**. Şu anda kimlerin bakım yaptığını [MAINTAINERS.md](https://github.com/hyperledger/iroha/blob/master/MAINTAINERS.md) dosyasından öğreniniz.

- Çalışmanızı bitirdiğinizde pull talebinizin **paketlenip birleştirilmesi**'nden sonra CI (devamlı entegrasyon) onaylarınının tamamını geçtiğinizinden emin olun.

- [C++ Stil Kılavuzu](#c-stil-kilavuzu)'na uyunuz.

- [Git Stil Kılavuzu](#git-stil-kilavuzu)'na uyunuz

- [Dokümantasyon Stil Kılavuzu](#dokumantasyon-stil-kilavuzu)'nu baz alarak **yeni kodu dokümante ediniz**.

- **Fork'lardan PR yaparken** [bu kılavuzu](https://help.github.com/articles/checking-out-pull-requests-locally) takip ediniz.


## Stil Kilavuzlari

### Git Stil Kilavuzu

- **Her commit'i imzalayın** bkz: [DCO](https://github.com/apps/dco): `Signed-off-by: $NAME <$EMAIL>`.  Bunu otomatik hale getirmek için  `git commit -s` komutunu kullanabilirsiniz.
- **Şimdiki zaman dilini kullanın** ("Özellik Ekleniyor", "Özellik Eklendi" değil).
- **Emrivaki konuşun** ("Docker'ı taşı...", "Docker'a taşır..." değil).
- Anlamlı gönderi (commit) mesajları yazın.
- Gönderi (commit) mesajının ilk satırını 50 karakter ile sınırlayın.
- Gönderi (commit) mesajının ilk satırı halledilmiş işin özeti, ikinci satırı boş, üçüncü ve diğer satırları ise değişiklikler listesini içermelidir.


### C++ Stil Kilavuzu

- clang-format [ayarları](https://github.com/hyperledger/iroha/blob/master/.clang-format) dosyasını kullanın. İnternette bununla ilgili kılavuzlar bulabilirsiniz (örneğin [Kratos wiki](https://github.com/KratosMultiphysics/Kratos/wiki/How-to-configure-clang%E2%80%90format))
- [CppCoreGuidelines](http://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines) ve  [Cpp Best Practices](https://lefticus.gitbooks.io/cpp-best-practices) kılavuzlarını kullanın.
- [Platforma-bağımlı](https://stackoverflow.com/questions/1558194/learning-and-cross-platform-development-c) kod yazmaktan kaçının.
- [C++14](https://en.wikipedia.org/wiki/C%2B%2B14) kullanın.
- Sınıf adları ve metodlar için [CamelCase](https://en.wikipedia.org/wiki/Camel_case), değişkenler için de [snake_case](https://en.wikipedia.org/wiki/Snake_case) kullanın.



### Dokümantasyon Stil Kilavuzu

- [Doxygen](http://www.stack.nl/~dimitri/doxygen/manual/docblocks.html) kullanın.
- Bütün ortak API'ları dokümante edin: metodlar, fonksiyonlar, üyeler, şablonlar, sınıflar ...


### Toplulugun Aktif Oldugu Yerler

Topluluğumuz şuralarda aktiftir:

| Servis       | Link                                                         |
| ------------ | ------------------------------------------------------------ |
| RocketChat   | https://chat.hyperledger.org/channel/iroha                   |
| StackOverflow| https://stackoverflow.com/questions/tagged/hyperledger-iroha |
| Posta Listesi| [hyperledger-iroha@lists.hyperledger.org](mailto:hyperledger-iroha@lists.hyperledger.org)                              |
| Gitter       | https://gitter.im/hyperledger-iroha/Lobby                    |
| Telegram     | https://t.me/hl_iroha                                        |
| YouTube      | https://www.youtube.com/channel/UCYlK9OrZo9hvNYFuf0vrwww     |



---

Dokümanı okuduğunuz için teşekkür ederiz.
