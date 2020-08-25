Kullanıcı-eş iletişimi için TLS yapılandırmak (torii)
=====================================================
Varsayılan olarak kullanıcı-eş iletişimi şifreli değildir.
Etkinleştirmek için şunları yapmanız lazım:

1. Her eş için bir anahtar/sertifika çifti `oluşturun <#generating-keys>`_
2. Bütün kullanıcılara sertifikaları dağıtın
3. Bu anahtarları kullanmak için irohad'ı `yapılandırın <#configuring-irohad>`_ 
4. Irohad'ı [tekrar] başlatın


Anahtar oluşturma
~~~~~~~~~~~~~~~~~

Anahtarlar PEM formatında sunulmalıdır. Onları oluşturmak için ``openssl`` kullanabilirsin:

.. code-block:: sh

    $ openssl genpkey -algorithm rsa -out server.key
    $ openssl req -new -key server.key -x509 -out server.crt

``openssl``'in desteklediği sürece ``rsa`` yerine istediğiniz herhangi 
bir algoritmayı kullanabilirsiniz.
Hangilerinin desteklendiğini öğrenmek için şunu kullanabilirsiniz:

.. code-block:: sh

    $ openssl list-public-key-algorithms

Eğer düğüme bağlanmak için düz IP adresleri kullanmaya ihtiyaç duyduysanız, sunucu sertifikanızda 
``subjectAltName``'i belirtmelisiniz, bunun için sertifikayı oluşturmadan 
önce openssl yapılandırmanızın ``v3_ca`` bölümüne bir ``subjectAltName`` 
yönergesi eklemeniz gerekir.
Örneğin, varsayılan kurulum için, ``/etc/ssl/openssl.cnf``:

.. code-block:: text

    [ v3_ca ]
    subjectAltName=IP:12.34.56.78

Sertifikadaki alanlar Common Namex (CN) haricinde önemli değil,
kullanıcının ana bilgisayar adına göre kontrol edilir ve eğer eşleşmedilerse
TLS anlaması hata verecek (örneğin eğer example.com:50051'a bağlantı kurarsanız, example.com'daki 
irohad'ın sertifikanın ortak adına example.com'a sahip olması gerekir.).

Irohad yapılanıdrması
~~~~~~~~~~~~~~~~~~~~~

Anahtarlarınızı kullanacak şekilde iroha'yı yapılandırmak için, ``torii_tls_params``yapılandırma 
parametresini modifiye etmeniz gerekir.

Aşağıdaki blok gibi görünmelidir:

.. code-block:: javascript

    "torii_tls_params": {
        "port": 55552,
        "key_pair_path": "/path/to/server"
    }

``port`` - bunu istediğiniz herhangi bir bağlantı noktasına kurar (fakat genellikle 
55552'yi istersiniz)

``key_pair_path`` - bunu anahtar/sertifika çiftinin tam yoluna kurar,
öyle ki eğer ``/path/to/server.key``'de bir anahtarınız ve ``/path/to/server.crt``'de 
bir sertifikanız varsa, şunu belirtmelisiniz
``torii_tls_keypair=/path/to/server``
