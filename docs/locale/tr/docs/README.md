# Iroha reStructuredTest Conceptual documentation

Bu dökümanın amacı Iroha defterinin işlevsel tarafı kadar dizaynı ve mimari yönlerini yapısal bir yaklaşım içinde aktarmaktır: 'nasıl yapılır'ları, kılavuzları ve örnekleri. Dökümana ReadTheDocs websitesi aracılığıyla ulaşılabilir ve Sphinx'te mevcut olan birçok formata türetilebilir. Katkıda bulunmak için [reStructuredTest](http://docutils.sourceforge.net/rst.html) sözdizimine aşina olunmalı ve dosyada tanımlanan ilkeler takip edilmelidir.

## İlkeler

 * sadece `image_assets` ve `source` dosyalarının içeriğini değiştir
 * `source/permissions` dosyasında herhangi bir değişiklik olması durumunda `yetkilendirme ayarları` yapılmalıdır
 * eğer yeni bölüm/dosya eklenirse — içindekilere eklenmelidir
 * eğer herhangi yeni ilke eklenirse — öncelikle GitHub konularında bir geliştirme önerisi olarak tartışılmalıdır
 * bizim yerel dosyalarımız resim varlıklarına veya diğer kaynaklara bağıntılı yolu kullanamayacağı için GitHub download linki veya harici bir servis kullanarak resimlere veya varlıklara referans vermek

## Kurulum

 Genellikle dökümanlara ReadTheDocs websitesi üzerinden erişilebilir. Sonucun yerel olarak kontrol edilmesine rağmen, bu rutinleri takip ederek manuel bir şekilde kurabilirsiniz:

### Önkoşullar

 * Python 2.7 veya Python 3.3+, ve pip'in kurulmuş olması
 * [Sphinx](http://www.sphinx-doc.org/en/stable/install.html)'in kurulu olması
 * Dökümanın/kaynağın içinde `pip install -r requirements.txt` çalıştırılması

### Kurulum Adımları

1. `cd docs/source`
1. `make permissions`
1. `make html`

Bundan sonra döküman `_build` dosyasının içinde html formatında oluşturulur. Diğer formatları Sphinx websitesinden veya sadece `make` yazarak kontrol edebilirsiniz. Projede kullanılan temanın sözdizimine aşina olmak için lütfen [demo websitesine](https://sphinx-rtd-theme.readthedocs.io/en/latest/demo/demo.html) gidin

### Hedef dil için dökümanın versiyonu nasıl oluşturulur

Esas itibarıyla döküman oluşturmanın akışı [Sphinx dökümanının](http://www.sphinx-doc.org/en/stable/intl.html#id1) sayfasında tanımlanmıştır. Kısacası, alttaki adımlar uygulanmalıdır:

1. `pip install sphinx-intl`
1. Orijinal ingilizce kaynak testinin her düzeltmesi için, `gettext` komutu burada olduğu gibi çağrılmalıdır: `make gettext`
1. Sphinx-intl ikilisini çağıran döküman için yerel ayarı güncelleme/yaratma: `sphinx-intl update -p _build/gettext -l de -l ja`, komutu Japonca ve Almanca yerel dosyaları yaratır.
1. Hedef proje bu komut ile oluşturulur `make -e SPHINXOPTS="-D language='de'" html` (Almanca için)

Mac'te `sphinx-intl` ikilisi ile ilgili sorunlar var mı? PATH'e ekleyip eklemediğinizi kontrol edin, genellikle bu şekilde olmalıdır: `$PATH:$HOME/Library/Python/2.7/bin`.

# Iroha Doxygen Documentation

Now, together with conceptual documentation we also have our auto-generated Doxygen technical documentation right on RTD.

## Where are the Doxygen docs located?

[Here](https://iroha.readthedocs.io/en/doxygen/index.html) :)

## How are they configured?

There are 2 files that affect Doxygen documentation build:
- docs/source/conf.py
- Doxyfile

The first adds the step of building the Doxygen files into RTD build and the second configures the Doxygen documentation.

## How to build documentation with Doxygen locally?

Easy – just build it as explained above (using `make html`), and do not forget to install Doxygen and Graphviz prior to doing that.
