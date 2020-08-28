=====================================
Iroha'yı Kubernetes kümesinde dağıtma
=====================================
.. TODO: Update the guide. https://soramitsu.atlassian.net/browse/DOPS-391
.. uyarı:: Bu kılavuzun bâzı bölümleri kullanımdan kaldırılmıştır. Kendi takdirinize bağlı olarak devam edin.

Bu kılavuzu takip ederek Terraform ve Kubespray kullanarak AWS bulutu üzerinde sıfırdan Kubernetes kümesini dağıtabileceksiniz ve üzerinde Iroha düğümlerinin ağını dağıtabileceksiniz.

Önkoşullar
^^^^^^^^^^
 * Linux (Ubuntu 16.04 üzerinde test edilmiş) ve MacOS çalıştıran bir makine
 * Python 3.3+
 * boto3
 * Ansible 2.4+
 * *ed25519-cli* anahtar üretimi için faydalı. Statik olarak bağlı ikili (x86_64 platformları için) deploy/ansible/playbooks/iroha-k8s/scripts rehberinde bulunabilir. `Kendiniz derlemeniz <https://github.com/Warchant/ed25519-cli>`__ gerekebilir.

Eğer zaten Kubernetes (k8s) kümesinde çalışıyorsanız aşağıdaki öğelere ihtiyac duymazsınız. `Iroha yapılandırmaları oluşturma`_ bölümünü geçebilirsiniz.

 * Terraform 0.11.8+
 * EC2'de k8s kümesi dağıtmak için AWS hesabı

Hazırlık
^^^^^^^^
Kaynakların yönetimi için AWS anahtarı almaya ihtiyacınız var.
Bunun için ayrı IAM kullanıcısı yaratmayı öneririz.
AWS konsolunuza gidin, "Güvenlik Kimlik Bilgilerim" menüsüne gidin ve "Kullanıcılar" bölümünde bir kullanıcı yaratın.
Bu kullanıcıya "AmazonEC2FullAccess" ve "AmazonVPCFullAccess" politikları atayın.
Güvenlik bilgileri sekmesindeki "Erişim anahtarı oluştur"a tıklayın.
Erişim anahtarı ID'si ve gizli anahtar değerlerini not alın.
Bu değişkenleri konsolunuzda ortam değişkenleri olarak ayarlayın:

.. code-block:: shell

    export AWS_ACCESS_KEY_ID='<The value of Access key ID>'
    export AWS_SECRET_ACCESS_KEY='<The value of Secret key>'

Github'ın kaynak ağacına göz atın:

.. code-block:: shell

    git clone https://github.com/hyperledger/iroha && cd iroha

Bulut altyapısının oluşturulması
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

AWS EC2 düşümlerinin birçok bölgede otomatik olarak dağıtılması için Hashicorp'un Terraform altyapı yönetim aracını kullanıyoruz. `Kubespray <https://github.com/kubernetes-incubator/kubespray>`__ Üretim-sınıfı bir k8s kümesi kurmak için Ansible modülü kullanılır.

Terraform mödülü 3 farklı bölgede 3 AWS örneği yaratır: varsayılan olarak, eu-west-1, eu-west-2, eu-west-3. Örnek tipi *c5.large*'dır. Her bölgede yaratılmış ayrı VPC'ler vardır. Bütün yaratılmış VPC'ler VPC eşleme bağlantısı kullanarak bağlanırlar. Yani k8s kümesi için kusursuz bir ağ yaratmaktır.

Birkaç yapılandırma seçeneği vardır: her bölgedeki düğümlerin sayısı ve onların k8s kümesindeki rolleri(kube-master or kube-node). *variables.tf* dosyasında veya ortam değişkenleri aracılığıyla ayarlanabilirler. (aynı değişken adını kullanıyor fakat TF_VAR ön ekiyle. `Terraform dökümanlarının <https://www.terraform.io/intro/getting-started/variables.html#from-environment-variables>`__ daha fazlasını görüntüleyin). Modülünün *variables.tf* dosyasında parametreleri ayarlayarak daha fazla seçenek yapılandırılabilir.

*deploy/tf/k8s/variables.tf*'daki SSH anahtarını da kurmalısınız. Kendi anahtarınız ile genel anahtarı değiştirin. Her yaratılmış EC2 örneğinde eklenecektir.

*deploy/tf/k8s* rehberinde gezininiz. Terraform'un öncelikle gerekli modülleri indirmesi gerekir:

.. code-block:: shell

    pushd deploy/tf/k8s && terraform init

Ardından modül yürütmesini çalıştırın:

.. code-block:: shell

    terraform apply && popd

Yürütme planını gözden geçiriniz ve onaylamak için *yes* yazınız. Bitmesi üzerine buna benzer bir çıktı görmelisiniz :

.. code-block:: shell

    Apply complete! Resources: 39 added, 0 changed, 0 destroyed.

Artık k8s kümesini dağıtmak için hazırız. Örnekler başlatılmadan önce birkaç dakika bekleyiniz.

K8s kümesinin kurulumu
^^^^^^^^^^^^^^^^^^^^^^
K8s kümesinin kurulumu için Yanıtlayıcı rolü vardır. Kubespray adı verilen harici bir modüldür. Hyperledger Iroha depolama alınındaki bir alt modül olarak saklanır. Bunun anlamı önce başlatılması gerekir:

.. code-block:: shell

    git submodule init && git submodule update

Bu komut ana depodan Kubespray'i indirecek.

Gerekli bağımlılıkları yükleyin:

.. code-block:: shell

    pip3 install -r deploy/ansible/kubespray/requirements.txt

Asıl küme dağıtımına geçiniz. Terraform yapılandırması boyunca önceden kullanılmış SSH özel anahtarlarına giden asıl yol ile *key-file* parametresinin yer değiştirdiğine emin olunuz. *REGIONS* değişkeni bir önceki adımda kullanılan bölgelerin varsayılan listesine karşılık gelir. MHerhangi birini ekleme veya çıkarma durumunuza göre değiştirin. Envanter dosyası etikete göre filtrelenen ana bilgisayarların Yanıtlayıcı-uyumlu listesini geri döndüren bir Python betiğidir.

.. code-block:: shell

    pushd deploy/ansible && REGIONS="eu-west-1,eu-west-2,eu-west-3" VPC_VISIBILITY="public" ansible-playbook -u ubuntu -b --ssh-extra-args="-o IdentitiesOnly=yes" --key-file=<PATH_TO_SSH_KEY> -i inventory/kubespray-aws-inventory.py kubespray/cluster.yml
    popd

Başarılı bir şekilde tamamlandığında çalışan k8s kümeye sahip olacaksınız..

Iroha yapılandırmalarını oluşturma
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Sırasıyla Iroha'nın uygun bir şekilde çalışması için her düğüm için bir anahtar çifti oluşturulması gerekir, genesis blok ve yapılandırma dosyası. Bu genellikle uğraştırıcı ve hataya açık bir prosedürdür, özellikle yüksek sayıdaki düğümler için. Yanıtlayıcı rolü ile otomatikleştirdik. Eğer 4 Iroha kopyası ile k8s kümesi için varsayılan yapılandırmaları kullanarak hızlı başlamak isterseniz `Kümede Irohayı dağıtma`_ bölümünü atlayabilirsiniz.

*N* Iroha düğümü için yapılandırma dosyalarını oluşturunuz. *replicas* değişkeni *N*'nin sayısını kontrol eder:

.. code-block:: shell

    pushd deploy/ansible && ansible-playbook -e 'replicas=7' playbooks/iroha-k8s/iroha-deploy.yml
    popd

*deploy/ansible/roles/iroha-k8s/files/conf*'da yaratılmış dosyaları bulmalısınız.

Kümede Iroha Dağıtmak
^^^^^^^^^^^^^^^^^^^^^
*deploy/ansible/roles/iroha-k8s/files*'da yapılandırma dosyalarına sahip olduğunuza emin olun. Özellikle, boş olmayan *conf* rehberi ve *k8s-iroha.yaml* dosyası.

K8s kümesini yönetmek için iki seçenek vardır: ana düğümde oturum açma ve burada komutları yürütme veya uzaktan yönetimi yapılandırma. İlki önemsiz olduğundan dolayı ikinci seçeneği ele alacağız.

Kubespray kullanarak kümeyi kurmanız durumunda */etc/kubernetes* rehberinde ana düğümlerden birinde *admin.conf* dosyasını bulabilirsiniz. Bu dosyayı kontrol makinesine kopyalayın (*kubectl* komutunu çalıştıracağınız komut). Dosyadaki *server* parametresinin ana düğümün harici IP adresini veya DNS adını işaret ettiğinden emin olun. Genellikle, düğümün gizli bir IP adresi vardır (AWS halinde). *kubectl* yardımcı programının kurulu olduğundan emin olun (Talimatlar için `dökümana göz atın <https://kubernetes.io/docs/tasks/tools/install-kubectl/>`__).

Varsayılan *kubectl* yapılandırmasını değiştirin:

.. code-block:: shell

    export KUBECONFIG=<PATH_TO_admin.conf>

Artık k8s kümesini uzaktan kontrol edebiliriz

*k8s-iroha.yaml* pod tanımlama dosyası öncelikle *config-map*'in yaratılmasını gerektirmektedir. Bu her bölmenin başlangıç konteynerinde takılı ve Iroha'yı çalıştırmak için  yapılandırma ve gerekli genesis blok dosyalarını içeren özel bir kaynaktır.

.. code-block:: shell

    kubectl create configmap iroha-config --from-file=deploy/ansible/roles/iroha-k8s/files/conf/

Her eş başlangıç konteynerinde takılı ve Iroha'nın kullanmak için kopyalanan Kubernetes sırrında depolanan genel ve özel anahtarlara sahiplerdir. Eşler yalnızca Iroha çalışırken atanmış sırlarını okuyabileceklerdir.

.. code-block:: shell

    kubectl create -f deploy/ansible/roles/iroha-k8s/files/k8s-peer-keys.yaml

Iroha ağ bölmesi tanımlamasını dağıtma:

.. code-block:: shell

    kubectl create -f deploy/ansible/roles/iroha-k8s/files/k8s-iroha.yaml

Her düğüm indirilmeden ve Docker konteynerleri başlamadan önce bir süre bekleyin. *kubectl get pods* komutunu çalıştırmak nihayetinde her *Running* durumundaki dağılmış bölmelerin listesini geri döndürmelidir.

.. İpucu:: Bölmeler bağlantı noktalarını harici olarak göstermezler. Ana makine adını kullanarak Iroha örneği ile bağlantı kurmanız gerekir (iroha-0, iroha-1, vb). Bunun için aynı ağda çalıştırma bölmelerine sahip olmanız gerekir.