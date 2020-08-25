Iroha kurulum güvenlik ipuçları
===============================
Bu kılavuz Iroha kurulumunun güvenliğini sağlamak için planlanmıştır. Bu kılavuzdaki adımların çoğu açık gözükebilir fakat gelecekte karşılaşacağınız muhtemel güvenlik problemlerinden kaçınmak için yardımcı olur.

Fiziksel güvenlik
^^^^^^^^^^^^^^^^^
Sunucuların yerel olarak bulunması durumunda (fiziksel olarak erişilebilir), bir dizi güvenlik önemleri uygulanmalıdır. Eğer bulut barındırma kullanılıyorsa bu adımları atlayınız.

Sunucu odasına yalnızca yetkili personel erişebileceği organizasyonel politika ve/veya kontrol erişim sistemi oluşturun.
Ardından, BIOS/aygıt yazılımının şifresini oluşturun ve yedek medyadan yetkisiz önyüklemeyi engellemek için önyükleme sıralamasını yapılandırın.
Eğer böyle bir fonksiyonalitesi varsa önyükleyicinin şifre koruması olduğundan emin olun. Ayrıca, yerinde bir CCTV izleme sistemine sahip olmak iyidir.

Yayılma
^^^^^^^
Öncelikle, `kaynak kodunu <https://github.com/hyperledger/iroha>`__ ve `Docker görüntülerini <https://hub.docker.com/r/hyperledger/iroha>`__ indirmek için kullanılan resmi depoalama alanını doğrulayın.
Kurulum sırasında kullanılan varsayılan şifreleri değiştirin, örneğin, postgres'e bağlanmak için olan şifre.
Iroha depolama alanı özel ve genel anahtarların örneklerini içerir - asla üretimde kullanmayınız.
Dahası, güvenli bir ortamda yaratılan yeni anahtar çiftleri oluştuğunu ve bu anahtar çiftlerine yalnızca yöneticilerin erişim yetkisi olduğunu doğrulayınız (veya en azından insan sayısının minimuma indirildiğini).
Iroha eşlerine anahtarlar dağıtıldıktan sonra dağıtımı gerçekleştirmek için kullanılan ana bilgisayardan özel anahtarları silin, başka bir deyişle özel anahtarlar yalnızca Iroha eşlerinin içinde bulunmalıdır.
Silmeden önce özel anahtarların şifreli bir yedeğini çıkarın ve erişimine sınır koyun.

Ağ Konfigürasyonu 
^^^^^^^^^^^^^^^^^
Eğer TLS etkinse Iroha 50051 ve 10001 bağlantı noktalarını dinler, ve opsiyonel olarak 55552'yi.
Güvenlik duvarı ayarları bu bağlantı noktalarına gelen/giden bağlantılara izin vermelidir.
Eğer mümkünse, dinlenen bağlantı noktalarıyla diğer ağ hizmetlerini devre dışı bırakın veya kaldırınız (FTP, DNS, LDAP, SMB, DHCP, NFS, SNMP, vb).
İdeal olarak, Iroha ağ açısından mümkün olduğunca izole edilmelidir.

Kullanıcı-eş iletişimini şifrelemek istiyorsanız, torii bağlantı noktalarında 
TLS'
Eğer trafik şifrelemesi kullanmıyorsanız, Docker yer paylaşımlı ağını kurmak için VPN veya Calico kullanmayı şiddetle öneririz, başka bir deyişle eşler arasındaki iletişimi şifrelemeye izin veren herhangi bir mekanizma.
Docker toplu iletişimleri varsayılan olarak şifreler, fakat güvenlik duvarı konfigürasyonundaki gerekli bağlantı noktalarını açmayı unutmayın.
VPN kullanılması durumunda, VPN anahtarının diğer kullanıcılar için kullanım dışı olduğunu doğrulayınız.

Eğer SSH kullanılıyorsa, sistem yöneticisi girişini devre dışı bırakın.
Onun dışında, şifre kimlik doğrulamasını devre dışı bırakın ve yalnızca anahtarları kullanın.
SSH işlem geçmişi seviyesini INFO olarak ayarlamak da yardımcı olabilir.

Eğer IPv6 kullanılmıyorsa, devre dışı bırakmak iyi bir fikir olabilir.

Güncellemeler
^^^^^^^^^^^^^
En son işletim sistemi güvenlik düzeltme eklemelerini yükleyin ve düzenli bir şekilde güncelleyin.
Eğer Iroha, Docker konteynerinde çalışıyorsa, Docker'ı düzenli bir şekilde güncelleyin.
Opsiyonel olmakla birlikte, üretim yüklenmeden önce ayrı bir sunucuda güncellemeleri test etmek iyi bir pratik kabul edilir.

İşlem geçmişi saklama ve görüntüleme
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
- Bir uç birim kullanarak özel bir makineye işlem geçmişini toplayın ve gönderin (örneğin, Filebeat).
- merkezi bir noktada bütün Iroha eşlerinden işlem geçmişini toplayın (örneğin, Logstash).
- İşlem geçmişini transfer edin ve şifreli bir kanal aracılığıyla bilgiyi izleyin (örneğin, https).
- İşlem geçmişine erişimden üçüncü şahısları önlemek için kimlik doğrulama mekanizması kurun.
- İşlem geçmişini göndermekten üçüncü şahısları önlemek için kimlik doğrulama mekanizması kurun.
- bütün yönetici erişimini işlem geçmişine kaydedin.

İşletim Sistemi Optimizasyonu
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Aşağıdaki adımlarda Docker'ın Iroha'yı çalıştırmak için kullanıldığı varsayılmaktadır.

- Docker Content Trust'ı etkinleştirin ve yapılandırın.
- Yalnızca güvenilir kullanıcıların Docker arka planını kontrol etmesine izin verin.
- Docker konteyner kaynakları için bir sınır belirleyin.

