CLI kılavuzu: ilk işlemlerini ve sorgularını gönderme
=====================================================

Çeşitli yollar kullanarak Iroha ile etkileşimde bulunabilirsiniz.
Iroha ile iletişim kuran çeşitli programlama 
dillerinde kod yazmak için kullanıcı kütüphanelerimizi 
kullanabilirsiniz (örneğin Java, Python, Javascript, Swift).
Alternatif olarak, Iroha ile etkileşim için komut satırı aracımız olan ``iroha-cli`` kullanabilirsiniz.
Bu kılavuzun bir parçası olarak, ``iroha-cli``'yı tanıyalım

.. Dikkat:: Buna rağmen ``iroha-cli`` muhtemelen Iroha ile çalışmaya başlamanın en basit yoludur,
  ``iroha-cli`` yalnızca bâzı muhtemel komutları/sorguları kapsar, bu yüzden kullanıcı deneyimi en iyisi olmayabilir.
  Eğer daha iyi bir CLI versiyonu oluşturmamıza yardım etmek isterseniz lütfen bize bildirin!

.. raw:: html

  <script src="https://asciinema.org/a/6dFA3CWHQOgaYbKfQXtzApDob.js" id="asciicast-6dFA3CWHQOgaYbKfQXtzApDob" async></script>

Yeni bir terminal açın (Iroha konteyneri ve ``irohad`` kurulmuş ve çalışıyor olmasına 
dikkat edin) ve bir ``iroha`` docker konteyneri ekleyin:

.. code-block:: shell

  docker exec -it iroha /bin/bash

Şimdi tekrar Iroha konteynerinin interaktif kabuğundasınız.
``iroha-cli``'yı başlatmaya ve istenen kullanıcının hesap adını geçmeye ihtiyacımız var.
Örneğimizde, ``admin`` hesabı zaten ``test`` alanında yaratıldı.
Iroha ile çalışmak için bu hesabı kullanalım.

.. code-block:: shell

  iroha-cli -account_name admin@test

.. not:: Tam hesap adı isim ile alan adı arasında bir ``@`` sembolüne sahiptir.
  Anahtar çiftinin aynı ada sahip olduğunu unutmayınız.

İlk İşlemi Yaratmak
^^^^^^^^^^^^^^^^^^^

Şimdi ``iroha-cli``'ın arayüzünü görebilirsiniz.
Yeni bir varlık yaratalım, admin hesabına biraz varlık ekleyelim ve diğer hesaba transfer edelim.
Bunu yapmak için, lütfen konsola ``tx`` veya ``1`` yazarak ``1. Yeni işlem (tx)`` seçeneğini seçin.

Şimdi mevcut komutların listesini görebilirsiniz.
Yeni bir varlık oluşturmayı deneyelim.
``14. Varlık Yarat (crt_ast)``'ı seçiniz.
Şimdi varlığınız için bir isim giriniz, örneğin ``coolcoin``.
Sonrasında, bir alan ID'si giriniz. Örneğimizde zaten``test`` alanımız var, bu yüzden onu kullanacağız.
Sonra varlık hassasiyeti girmeye ihtiyacımız var
– fraksiyonel bölümündeki sayıların miktarı.
Hassaslığı ``2`` olarak ayarlayalım.

Tebrikler, ilk komutunuzu yarattınız ve onu bir işleme eklediniz!
Iroha'ya gönderebilir veya daha fazla komutlar ekleyebilirsiniz
``1. İşleme bir tane daha komut ekleyin (ekle)``.
Daha fazla komut ekleyelim, böylece tek seferde herşeyi yapabiliriz. ``add`` yazın.

Şimdi hesabımıza ``coolcoins`` eklemeyi deneyelim.
``16. Varlık Miktarı Ekle (add_ast_qty)``'yi seçiniz, varlık ID'sini giriniz – ``coolcoin#test``,
tamsayı bölümü ve ``coolcoin#test``, tamsayı bölümü ve hassasiyet.
Örneğin, 200,50 hassasiyet eklemek için.
Örneğin, 200.50 ``coolcoins`` eklemek için, ``coolcoins`` tamsayısını girmemiz gerekir,
Tamsayı bölümünü ``20050`` olarak girmemiz gerekir ve hassasiyet bölümünü ``20050`` 
olarak ve hassaslığı ``2`` olarak girmemiz gerekir böylece ``200.50`` olur.

.. not:: Tam varlık adı isim ile alan adı arasında bir ``#`` sembolüne sahiptir.

Bir tane daha komut ekleyip ``5. Varlıkları Transfer Et (tran_ast)``'i seçerek
``admin@test``'den ``test@test``'e 100.50 ``coolcoins`` transfer edelim.
Kaynak Hesabı ve Hedef Hesabı giriniz, bizim durumumuzda ``admin@test``
ve ``test@test``, Varlık ID'si (``coolcoin#test``), tamsayı bölümü ve hassasiyet (``10050`` ve ``2``).

Şimdi Iroha eşine işlemimizi göndermeye ihtiyacımız var (``2. Iroha Eşine Gönder (gönder)``).
Eş adresini giriniz (bizim durumumuzda ``localhost``) ve bağlantı noktası (``50051``).
Şimdi işleminiz gönderildi ve işlem karışımınızı görebilirsiniz.
İşlemin durumunu kontrol etmek için kullanabilirsiniz.

``irohad``'ın çalıştığı terminale geri dönün.
İşleminizin işlem geçmişini görebilirsiniz.

Yaşasın! Iroha'ya ilk işleminizi gönderdiniz.

İlk Sorguyu Yaratmak
^^^^^^^^^^^^^^^^^^^^

Şimdi ``coolcoins``'in başarılı bir şekilde ``admin@test``'den ``test@test``'e transfer edilip edilmediğini kontrol edelim.
``2. Yeni sorgu (qry)``'yu seçiniz.
``8. Hesabın Varlıklarını Al (get_acc_ast)`` ``test@test``'in şu anda ``coolcoin``'e sahip olup olmadığını kontrol etmek için size yardımcı olabilir.
Komutlar ve ``1. Iroha Eşine gönder (gönder)`` ile yaptığınız komutlara benzer şekilde bir sorgu oluşturunuz.
Şimdi kaç tane ``coolcoin``'in ``test@test``'e sahip olduğu hakkında bilgiyi görebiliriz.
Buna benzeyecek:

.. code-block:: shell

  [2018-03-21 12:33:23.179275525][th:36][info] QueryResponseHandler [Account Assets]
  [2018-03-21 12:33:23.179329199][th:36][info] QueryResponseHandler -Account Id:- test@test
  [2018-03-21 12:33:23.179338394][th:36][info] QueryResponseHandler -Asset Id- coolcoin#test
  [2018-03-21 12:33:23.179387969][th:36][info] QueryResponseHandler -Balance- 100.50

Harika değil mi?
Iroha'ya ilk sorgunuzu gönderdiniz ve bir yanıt aldınız!

.. ipucu:: Bütün mevcut komutlar ve sorgular hakkında bilgi edinmek için lütfen API bölümümüzü kontrol ediniz.

Kötü Niyetli Olmak
^^^^^^^^^^^^^^^^^^

Kötü niyetli olmayı ve Iroha'yı aldatmayı deneyelim. Örneğin, ``admin@test``'in sahip olduğundan daha fazla ``coolcoins`` transfer edelim.
``admin@test``'den ``test@test``'e 100000.00 ``coolcoins`` transfer etmeyi deneyiniz.
Tekrar, ``1. Yeni işlem (tx)``, ``5. Varlıkları Transfer Et (tran_ast)``'a ilerleyin,
Kaynak Hesabı ve Hedef Hesabı girin, bizim durumumuzda ``admin@test`` ve ``test@test``, Varlık ID'si (``coolcoin#test``),
tamsayı bölümü ve hassasiyet (``10000000`` ve ``2``).
Daha önce yaptığınız gibi Iroha eşine bir işlem gönderin.
Diyor ki:

.. code::

  [2018-03-21 12:58:40.791297963][th:520][info] TransactionResponseHandler Transaction successfully sent
  Congratulation, your transaction was accepted for processing.
  Its hash is fc1c23f2de1b6fccbfe1166805e31697118b57d7bb5b1f583f2d96e78f60c241

`Your transaction was accepted for processing`.
Bu, Iroha'yı başarıyla kandırdığımız anlamına mı geliyor?
İşlemin durumunu görmeyi deneyelim.
``3. Yeni işlem durumu isteği (st)``'ni seçiniz ve önceki komuttan sonra konsolda alabileceğiniz işlem karışımını giriniz.
Iroha'ya gönderelim.
Şöyle yanıtladı:

.. code::

  Transaction has not passed stateful validation.

Görünüşe göre hayır.
İşlemimiz kabul edilmedi çünkü durumsal doğrulamayı geçmedi ve ``coolcoins``'e transfer edilmedi.
Emin olmak için sorgularla ``admin@test`` ve ``test@test``'in durumunu kontrol edebilirsiniz (daha önce yaptığımız gibi).
