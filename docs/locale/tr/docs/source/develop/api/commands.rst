Komutlar
========

Bir komut sistemdeki bir varlık (varlık, hesap) üzerinde bir eylem gerçekleştirerek World State View adı verilen bir durumu değiştirir.
Herhangi bir komut bir eylemi gerçekleştirmek için bir işlemde bulunmalıdır.

Varlık miktarı eklemek
----------------------

Amaç
^^^^

Varlık miktarı ekleme komutunun amacı işlem yaratıcının hesabındaki bir varlığın miktarını arttırmaktır.
Kullanım senaryosu bir mal üzerinde bir iddia olarak hareket edilebilinen bir sistemdeki değişken bir varlığın sayısının arttırılmasıdır (örneğin para, altın, vb.)

Şema
^^^^

.. code-block:: proto

    message AddAssetQuantity {
        string asset_id = 1;
        string amount = 2;
    }

.. not::
    Bilinen bir sorundan dolayı geçersiz kesinlik değeri geçerseniz herhangi bir kural dışı işlem uyarısı alamayacağınızı lütfen unutmayın.
    Geçerli aralık: 0 <= hassasiyet <= 255


Yapı
^^^^

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Asset ID", "id of the asset", "<asset_name>#<domain_id>", "usd#morgan"
    "Amount", "positive amount of the asset to add", "> 0", "200.02"

Onaylama
^^^^^^^^

1. Varlık ve hesap var olmalıdır
2. Eklenen miktar hassasiyeti varlık hassasiyetine eşit olmalıdır
3. İşlem yaratıcısı varlık yaratmak için yetkilendirilmiş bir role sahip olmalıdır

Muhtemel Durumsal Onaylama Hataları
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not add asset quantity", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Command's creator does not have permission to add asset quantity", "Grant the necessary permission"
    "3", "No such asset", "Cannot find asset with such name or such precision", "Make sure asset id and precision are correct"
    "4", "Summation overflow", "Resulting asset quantity is greater than the system can support", "Make sure that resulting quantity is less than 2^256 / 10^asset_precision"

Eş ekle
-------

Amaç
^^^^

Eş ekleme komutunun amacı eş ağına eş eklemesi durumunu deftere yazmaktır.
AddPeer ile bir işlem işlendikten sonra konsensüs ve senkronizasyon bileşenleri bunu kullanmaya başlayacaktır.

Şema
^^^^

.. code-block:: proto

    message Peer {
        string address = 1;
        bytes peer_key = 2; // hex string
    }

    message AddPeer {
        Peer peer = 1;
    }

Yapı
^^^^

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 10, 30

    "Address", "resolvable address in network (IPv4, IPv6, domain name, etc.)", "should be resolvable", "192.168.1.1:50541"
    "Peer key", "peer public key, which is used in consensus algorithm to sign-off vote, commit, reject messages", "ed25519 public key", "292a8714694095edce6be799398ed5d6244cd7be37eb813106b217d850d261f2"

Onaylama
^^^^^^^^

1. Eş anahtarı özgündür (böyle bir genel anahtarla başka eş yoktur)
2. İşlem yaratıcısı CanAddPeer yetkisine sahip bir role sahiptir
3. Böyle bir ağ adresi henüz eklenmedi

Muhtemel Durumsal Onaylama Hataları
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not add peer", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Command's creator does not have permission to add peer", "Grant the necessary permission"

İmza sahibi ekleme
------------------

Amaç
^^^^

İmza sahibi ekleme komutunun amacı hesaba tanımlayıcı eklemektir.
Böyle bir tanımlayıcı başka bir aygıtın genel anahtarı veya başka bir kullanıcının genel anahtarıdır. 

Şema
^^^^

.. code-block:: proto

    message AddSignatory {
        string account_id = 1;
        bytes public_key = 2;
    }

Yapı
^^^^

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Account ID", "Account to which to add signatory", "<account_name>@<domain_id>", "makoto@soramitsu"
    "Public key", "Signatory to add to account", "ed25519 public key", "359f925e4eeecfdd6aa1abc0b79a6a121a5dd63bb612b603247ea4f8ad160156"

Onaylama
^^^^^^^^

İki durum:

    Durum 1. İşlem yaratıcısı hesabına CanAddSignatory yetkilendirmesine sahip bir imza sahibi eklemek ister. 

    Durum 2. CanAddSignatory işlem yaratıcıya verildi.

Muhtemel Durumsal Onaylama Hataları
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not add signatory", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Command's creator does not have permission to add signatory", "Grant the necessary permission"
    "3", "No such account", "Cannot find account to add signatory to", "Make sure account id is correct"
    "4", "Signatory already exists", "Account already has such signatory attached", "Choose another signatory"

Rol ekle
--------

Amaç
^^^^

Rol ekleme komutunun amacı bir hesabın sistemde bâzı yaratılmış rollere yükseltilmesidir. Bu rol hesabın gerçekleştirmek zorunda olduğu yetkilendirme kümesidir. (komut veya sorgu).

Şema
^^^^

.. code-block:: proto

    message AppendRole {
       string account_id = 1;
       string role_name = 2;
    }

Yapı
^^^^

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Account ID", "id or account to append role to", "already existent", "makoto@soramitsu"
    "Role name", "name of already created role", "already existent", "MoneyCreator"

Onaylama
^^^^^^^^

1. Rol sistemde var olmalıdır
2. İşlem yaratıcı rol eklemek için yetkiye sahip olmalıdır (CanAppendRole)
3. Rol ekleyen hesap rollerinde ekli rolün üst kümesi olan yetkilere sahiptir. (başka bir deyişle kimse işlem yaratıcısından daha güçlü bir rol ekleyemez)

Muhtemel Durumsal Onaylama Hataları
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not append role", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Command's creator does not have permission to append role", "Grant the necessary permission"
    "3", "No such account", "Cannot find account to append role to", "Make sure account id is correct"
    "4", "No such role", "Cannot find role with such name", "Make sure role id is correct"

Çağrı motoru
------------

Amaç
^^^^

Çağrı motorunun amacı Iroha EVM ile yeni bir sözleşme yapmak veya zaten var olan bir akıllı sözleşme metodunu çağırmaktır.
Akıllı sözleşmenin çalışması bu komutu içeren bir işlemin bir bloğa kabul edilmesi ve bloğun işlenmesini sağlayan defterin durumunu potansiyel olarak değiştirebilir.

Şema
^^^^

.. code-block:: proto

    message CallEngine {
        string caller = 1;  // hex string
        oneof opt_callee {
            string callee = 2;  // hex string
        }
        string input = 3;   // hex string
    }

Yapı
^^^^

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"

    "Caller", "Iroha account ID of an account on whose behalf the command is run", "<account_name>@<domain_id>", "test@mydomain"
    "Callee", "the EVM address of a deployed smart contract", "20-bytes string in hex representation", "7C370993FD90AF204FD582004E2E54E6A94F2651"
    "Input", "Bytecode of a smart contract for a newly deployed contracts or ABI-encoded string of the contract method selector followed by the `set of its arguments <https://solidity.readthedocs.io/en/v0.6.5/abi-spec.html>`_", "Hex string", "40c10f19000000000000000000000000969453762b0c739dd285b31635efa00e24c2562800000000000000000000000000000000000000000000000000000000000004d2"

Onaylama
^^^^^^^^

1. Arayan geçerli bir Iroha hesabı ID'sidir.
2. İşlem yaratıcısı CanCallEngine yetkisiyle bir rolü vardır.

Muhtemel Durumsal Onaylama Hataları
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Engine is not configured", "This error means that Iroha was built without Burrow EVM", "See `Build <../../build/index.html#main-parameters>`_ section of documentation to build Iroha correctly"
    "2", "No such permissions", "Command’s creator does not have a permission to call EVM engine", "Grant the necessary permission"
    "3", "CallEngine error", "Code execution in EVM failed; the reason can be both in the contract code itself or be rooted in nested Iroha commands call", "Investigation of the error root cause is required in order to diagnose the issue"

Hesap yaratmak
--------------

Amaç
^^^^

Hesap yaratma komutunun amacı sistemde işlem veya sorgu gönderebilen, imza sahiplerini, kişisel verileri ve tanımlayıcıları saklayabilen bir varlık yaratmaktır.

Şema
^^^^

.. code-block:: proto

    message CreateAccount {
        string account_name = 1;
        string domain_id = 2;
        bytes public_key = 3;
    }

Yapı
^^^^

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Account name", "domain-unique name for account", "`[a-z_0-9]{1,32}`", "morgan_stanley"
    "Domain ID", "target domain to make relation with", "should be created before the account", "america"
    "Public key", "first public key to add to the account", "ed25519 public key", "407e57f50ca48969b08ba948171bb2435e035d82cec417e18e4a38f5fb113f83"

Onaylama
^^^^^^^^

1. İşlem yaratıcı bir hesap yaratmak için yetkiye sahiptir
2. domain_id olarak iletilen alan adı zaten sistemde oluşturuldu
3. Hesabın ilk genel anahtarı olmadan veya çok imzalı bir hesaba eklenmiş olmadan önce böyle bir genel anahtar eklenmedi

Muhtemel Durumsal Onaylama Hataları
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not create account", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Command's creator either does not have permission to create account or tries to create account in a more privileged domain, than the one creator is in", "Grant the necessary permission or choose another domain"
    "3", "No such domain", "Cannot find domain with such name", "Make sure domain id is correct"
    "4", "Account already exists", "Account with such name already exists in that domain", "Choose another name"

Varlık yaratmak
---------------

Amaç
^^^^

Varlık yaratma komutunun amacı bir alanda özgün yeni tip bir varlık yaratmaktır.
Bir varlık bir metanın sayılabilir bir temsiliyetidir.

Şema
^^^^

.. code-block:: proto

    message CreateAsset {
        string asset_name = 1;
        string domain_id = 2;
        uint32 precision = 3;
    }

.. not::
    Bilinen bir sorundan dolayı geçersiz kesinlik değeri geçerseniz herhangi bir kural dışı işlem uyarısı alamayacağınızı lütfen unutmayın.
    Geçerli aralık: 0 <= hassasiyet <= 255

Yapı
^^^^

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Asset name", "domain-unique name for asset", "`[a-z_0-9]{1,32}`", "soracoin"
    "Domain ID", "target domain to make relation with", "RFC1035 [#f1]_, RFC1123 [#f2]_", "japan"
    "Precision", "number of digits after comma/dot", "0 <= precision <= 255", "2"

Onaylama
^^^^^^^^

1. İşlem yaratıcısı varlık yaratmak için yetkiye sahiptir
2. Varlık adı alanda özgündür

Muhtemel Durumsal Onaylama Hataları
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not create asset", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Command's creator does not have permission to create asset", "Grant the necessary permission"
    "3", "No such domain", "Cannot find domain with such name", "Make sure domain id is correct"
    "4", "Asset already exists", "Asset with such name already exists", "Choose another name"

Alan yaratmak
-------------

Amaç
^^^^

Alan yaratmak komutunun amacı Iroha ağında hesapların grubu olan yeni alan oluşturmaktır.

Şema
^^^^

.. code-block:: proto

    message CreateDomain {
        string domain_id = 1;
        string default_role = 2;
    }

Yapı
^^^^

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Domain ID", "ID for created domain", "unique, RFC1035 [#f1]_, RFC1123 [#f2]_", "japan05"
    "Default role", "role for any created user in the domain", "one of the existing roles", "User"

Onaylama
^^^^^^^^

1. Alan ID'si özgündür
2. İşlemdeki bu komutu gönderen hesap alan yaratmak için yetkilendirmeye sahip bir role sahiptir
3. Varsayılan olarak yaratılan kullanıcıya atanacak rol sistemde bulunur

Muhtemel Durumsal Onaylama Hataları
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not create domain", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Command's creator does not have permission to create domain", "Grant the necessary permission"
    "3", "Domain already exists", "Domain with such name already exists", "Choose another domain name"
    "4", "No default role found", "Role, which is provided as a default one for the domain, is not found", "Make sure the role you provided exists or create it"

Rol yaratmak
------------

Amaç
^^^^

Rol yaratma komutunun amacı yetkilerin kümesinden sistemde yeni bir rol yaratmaktır.
Farklı yetkileri rollerle birleştiren Iroha eş ağı bakımcıları özelleştirilmiş güvenlik modeli yaratabilirler.

Şema
^^^^

.. code-block:: proto

    message CreateRole {
        string role_name = 1;
        repeated RolePermission permissions = 2;
    }

Yapı
^^^^

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Role name", "name of role to create", "`[a-z_0-9]{1,32}`", "User"
    "RolePermission", "array of already existent permissions", "set of passed permissions is fully included into set of existing permissions", "{can_receive, can_transfer}"

Onaylama
^^^^^^^^

1. Geçirilen izinler kümesi var olan yetkilerin kümesine tam olarak dahil edilir
2. Yetkilerin kümesi boş değildir

Muhtemel Durumsal Onaylama Hataları
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not create role", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Command's creator does not have permission to create role", "Grant the necessary permission"
    "3", "Role already exists", "Role with such name already exists", "Choose another role name"

Rol ayırmak
-----------

Amaç
^^^^

Rol ayırmak komutunun amacı bir hesabın rollerinin kümesinden bir rolü ayırmaktır.
Bu komutu çalıştırarak kullanıcı için sistemde muhtemel eylemlerin sayısını düşürmek mümkündür.

Şema
^^^^

.. code-block:: proto

    message DetachRole {
        string account_id = 1;
        string role_name = 2;
    }

Yapı
^^^^

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Account ID", "ID of account where role will be deleted", "already existent", "makoto@soramitsu"
    "Role name", "a detached role name", "existing role", "User"

Onaylama
^^^^^^^^

1. Rol sistemde vardır
2. Hesap bu role sahiptir

Muhtemel Durumsal Onaylama Hataları
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not detach role", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Command's creator does not have permission to detach role", "Grant the necessary permission"
    "3", "No such account", "Cannot find account to detach role from", "Make sure account id is correct"
    "4", "No such role in account's roles", "Account with such id does not have role with such name", "Make sure account-role pair is correct"
    "5", "No such role", "Role with such name does not exist", "Make sure role id is correct"

Yetki vermek
------------

Amaç
^^^^

Yetki vermek komutunun amacı başka bir hesaba işlem gönderenin hesabında işlem yapma hakkı verir (birisine hesabımla birşeyler yapma hakkı vermek).

Şema
^^^^

.. code-block:: proto

    message GrantPermission {
        string account_id = 1;
        GrantablePermission permission = 2;
    }

Yapı
^^^^

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Account ID", "id of the account to which the rights are granted", "already existent", "makoto@soramitsu"
    "GrantablePermission name", "name of grantable permission", "permission is defined", "CanTransferAssets"


Onaylama
^^^^^^^^

1. Hesap vardır
2. İşlem yaratıcı bu yetkiyi vermek için izin verir

Muhtemel Durumsal Onaylama Hataları
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not grant permission", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Command's creator does not have permission to grant permission", "Grant the necessary permission"
    "3", "No such account", "Cannot find account to grant permission to", "Make sure account id is correct"

Eş kaldırmak
------------

Amaç
^^^^

Eş kaldırmak komutunun amacı ağdan eş kaldırma durumunu deftere yazmaktır.
RemovePeer ile işlem işlendikten sonra, konsensüs ve senkronizasyon bileşenleri bunu kullanmaya başlayacaktır.

Şema
^^^^

.. code-block:: proto

    message RemovePeer {
        bytes public_key = 1; // hex string
    }

Yapı
^^^^

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 10, 30

    "Public key", "peer public key, which is used in consensus algorithm to sign vote messages", "ed25519 public key", "292a8714694095edce6be799398ed5d6244cd7be37eb813106b217d850d261f2"

Onaylama
^^^^^^^^

1. Ağda birden fazla eş vardır
2. İşlem yaratıcı CanRemovePeer yetkisine sahip bir role sahiptir
3. Eş ağa önceden eklenmiş olmalıdır

Muhtemel Durumsal Onaylama Hataları
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not remove peer", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Command's creator does not have permission to remove peer", "Grant the necessary permission"
    "3", "No such peer", "Cannot find peer with such public key", "Make sure that the public key is correct"
    "4", "Network size does not allow to remove peer", "After removing the peer the network would be empty", "Make sure that the network has at least two peers"

İmza sahibi kaldırmak
---------------------

Amaç
^^^^

İmza sahibi kaldırmak komutunun amacı bir hesaptan bir kimlikle ilişkili genel anahtarı kaldırmaktır

Şema
^^^^

.. code-block:: proto

    message RemoveSignatory {
        string account_id = 1;
        bytes public_key = 2;
    }

Yapı
^^^^

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Account ID", "id of the account to which the rights are granted", "already existent", "makoto@soramitsu"
    "Public key", "Signatory to delete", "ed25519 public key", "407e57f50ca48969b08ba948171bb2435e035d82cec417e18e4a38f5fb113f83"

Onaylama
^^^^^^^^

1. İmza sahibi silindiğinde, **boyutun(imza sahibinin) sabit niceliği >= yeterli çoğunluk** olup olmadığını kontrol etmeliyiz
2. İmza sahibi hesaba daha önceden eklenmiş olmalıdır 

İki durum:

    Durum 1. İşlem yaratıcısı hesabından imza sahibini kaldırmak istediğinde ve CanRemoveSignatory yetkisine sahip olduğunda

    Durum 2. CanRemoveSignatory işlem yaratıcısına verildi 

Muhtemel Durumsal Onaylama Hataları
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not remove signatory", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Command's creator does not have permission to remove signatory from his account", "Grant the necessary permission"
    "3", "No such account", "Cannot find account to remove signatory from", "Make sure account id is correct"
    "4", "No such signatory", "Cannot find signatory with such public key", "Make sure public key is correct"
    "5", "Quorum does not allow to remove signatory", "After removing the signatory account will be left with less signatories, than its quorum allows", "Reduce the quorum"

İzni iptal etmek
----------------

Amaç
^^^^

İzni iptal etmek komutunun amacı ağda bir diğer hesaptan verilmiş iznin iptali veya reddidir.

Şema
^^^^

.. code-block:: proto

    message RevokePermission {
        string account_id = 1;
        GrantablePermission permission = 2;
    }

Yapı
^^^^

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: auto

        "Account ID", "id of the account to which the rights are granted", "already existent", "makoto@soramitsu"
        "GrantablePermission name", "name of grantable permission", "permission was granted", "CanTransferAssets"

Onaylama
^^^^^^^^

İşlem yaratıcısı hedef hesaba daha önce verilmiş bu izne sahip olmalıdır

Muhtemel Durumsal Onaylama Hataları
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not revoke permission", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Command's creator does not have permission to revoke permission", "Grant the necessary permission"
    "3", "No such account", "Cannot find account to revoke permission from", "Make sure account id is correct"

Hesap ayrıntılarını ayarlama
----------------------------

Amaç
^^^^

Hesap ayrıntılarını ayarlama komutunun amacı verilen hesap için anahtar-değer bilgisini ayarlamaktır 

.. uyarı:: Eğer zaten depoda verilen anahtar için bir değer varsa yeni değer ile değiştirilecektir

Şema
^^^^

.. code-block:: proto

    message SetAccountDetail{
        string account_id = 1;
        string key = 2;
        string value = 3;
    }

Yapı
^^^^

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Account ID", "id of the account to which the key-value information was set", "already existent", "makoto@soramitsu"
    "Key", "key of information being set", "`[A-Za-z0-9_]{1,64}`", "Name"
    "Value", "value of corresponding key", "≤ 4096", "Makoto"

Onaylama
^^^^^^^^

Üç durum:

    Durum 1. İşlem yaratıcı diğer kişinin hesabının hesap detayını ayarlamak istediğinde ve yaratıcı `can_set_detail <../api/permissions.html#can-set-detail>`_ yetkisine sahip olduğunda.

    Durum 2. `can_set_my_account_detail <../api/permissions.html#can-set-my-account-detail>`_ hedef hesabın hesap detaylarını ayarlamasına izin vermek için işlem yaratıcısına verilir.  

    Durum 3. Hesap sahibi kendi hesap detaylarını ayarlamak isterken – yetkiye ihtiyaç duymaz.

Muhtemel Durumsal Onaylama Hataları
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not set account detail", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Command's creator does not have permission to set account detail for another account", "Grant the necessary permission"
    "3", "No such account", "Cannot find account to set account detail to", "Make sure account id is correct"

Hesap yeterli çoğunluğunu ayarlamak
-----------------------------------

Amaç
^^^^

Hesap yeterli çoğunluğunu ayarlamak komutunun amacı işlemi oluşturan bir kullanıcının kimliğini doğrulamak için gereken imza sahiplerinin sayısını ayarlamaktır.
Kullanım senaryosu işlemi kapatmak için tek bir hesap kullanarak farklı kullanıcıların sayısını ayarlamaktır.

Şema
^^^^

.. code-block:: proto

    message SetAccountQuorum {
        string account_id = 1;
        uint32 quorum = 2;
    }

Yapı
^^^^

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Account ID", "ID of account to set quorum", "already existent", "makoto@soramitsu"
    "Quorum", "number of signatories needed to be included within a transaction from this account", "0 < quorum ≤ public-key set up to account ≤ 128", "5"

Onaylama
^^^^^^^^

Yeterli çoğunluk ayarlandığında, **boyutun(imza sahibinin) sabit niceliği >= yeterli çoğunluk** olup olmadığı kontrol edilir.

İki durum:

    Durum 1. işlem yaratıcı hesabı için yeterli çoğunluğu ayarlamak istediğinde ve CanRemoveSignatory yetkisine sahip olduğunda

    Durum 2. CanRemoveSignatory işlem yaratıcısına verilir

Muhtemel Durumsal Onaylama Hataları
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not set quorum", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Command's creator does not have permission to set quorum for his account", "Grant the necessary permission"
    "3", "No such account", "Cannot find account to set quorum to", "Make sure account id is correct"
    "4", "No signatories on account", "Cannot find any signatories attached to the account", "Add some signatories before setting quorum"
    "5", "New quorum is incorrect", "New quorum size is less than account's signatories amount", "Choose another value or add more signatories"

Varlık miktarını çıkartmak
--------------------------

Amaç
^^^^

Varlık miktarını çıkartmak komutunun amacı AddAssetQuantity komutunun tersidir — işlem yaratıcı hesabındaki varlıkların sayısını düşürmek.

Şema
^^^^

.. code-block:: proto

    message SubtractAssetQuantity {
        string asset_id = 1;
        string amount = 2;
    }

.. not::
    Bilinen bir sorundan dolayı geçersiz kesinlik değeri geçerseniz herhangi bir kural dışı işlem uyarısı alamayacağınızı lütfen unutmayın.
    Geçerli aralık: 0 <= hassasiyet <= 255

Yapı
^^^^

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Asset ID", "id of the asset", "<asset_name>#<domain_id>", "usd#morgan"
    "Amount", "positive amount of the asset to subtract", "> 0", "200"

Onaylama
^^^^^^^^

1. Varlık ve hesap var olmalıdır
2. Eklenmiş miktar hassasiyeti varlık hassasiyetine eşit olmalıdır
3. İşlem yaratıcısı varlıkları çıkarmak için yetkilendirilmiş bir role sahip olmalıdır

Muhtemel Durumsal Onaylama Hataları
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not subtract asset quantity", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Command's creator does not have permission to subtract asset quantity", "Grant the necessary permission"
    "3", "No such asset found", "Cannot find asset with such name or precision in account's assets", "Make sure asset name and precision are correct"
    "4", "Not enough balance", "Account's balance is too low to perform the operation", "Add asset to account or choose lower value to subtract"

Varlık transferi
----------------

Amaç
^^^^

Varlık transferi komutunun amacı eş ağında hesap içinde varlıkları paylaşmaktır: kaynak hesabın hedef hesaba varlıkları transfer etmesi biçiminde.

Şema
^^^^

.. code-block:: proto

    message TransferAsset {
        string src_account_id = 1;
        string dest_account_id = 2;
        string asset_id = 3;
        string description = 4;
        string amount = 5;
    }

Yapı
^^^^

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Source account ID", "ID of the account to withdraw the asset from", "already existent", "makoto@soramitsu"
    "Destination account ID", "ID of the account to send the asset to", "already existent", "alex@california"
    "Asset ID", "ID of the asset to transfer", "already existent", "usd#usa"
    "Description", "Message to attach to the transfer", "Max length of description (set in genesis block, by default is 64)", "here's my money take it"
    "Amount", "amount of the asset to transfer", "0 <= precision <= 255", "200.20"

Onaylama
^^^^^^^^

1. Kaynak hesap AccountHasAsset ilişkisindeki bu varlığa sahiptir [#f1]_
2. Miktar pozitif bir sayıdır ve varlık hassasiyeti varlık tanımı ile tutarlıdır
3. Kaynak hesap transfer etmek için yeterli miktarda varlığa sahiptir ve sıfır değildir
4. Kaynak hesap para transfer edebilir ve hedef hesap para alabilir (rolleri bu yetkilere sahiptir)

Muhtemel Durumsal Onaylama Hataları
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not transfer asset", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Command's creator does not have permission to transfer asset from his account", "Grant the necessary permission"
    "3", "No such source account", "Cannot find account with such id to transfer money from", "Make sure source account id is correct"
    "4", "No such destination account", "Cannot find account with such id to transfer money to", "Make sure destination account id is correct"
    "5", "No such asset found", "Cannot find such asset", "Make sure asset name and precision are correct"
    "6", "Not enough balance", "Source account's balance is too low to perform the operation", "Add asset to account or choose lower value to subtract"
    "7", "Too much asset to transfer", "Resulting asset quantity of destination account would exceed the allowed maximum", "Make sure that the final destination value is less than 2^256 / 10^asset_precision"

.. [#f1] https://www.ietf.org/rfc/rfc1035.txt
.. [#f2] https://www.ietf.org/rfc/rfc1123.txt

Hesap detaylarını ayarlamak ve karşılaştırmak
---------------------------------------------

Amaç
^^^^

Hesap detaylarını ayarlamak ve karşılaştırmak komutunun amacı eğer eski değer geçen değer ile eşleşirse verilen hesap için anahtar-değer bilgisini ayarlamaktır.

Şema
^^^^

.. code-block:: proto

    message CompareAndSetAccountDetail{
        string account_id = 1;
        string key = 2;
        string value = 3;
        oneof opt_old_value {
            string old_value = 4;
        }
    }

.. not::
    Dikkat, old_value alanı opsiyoneldir.
    Bunun nedeni anahtar-değer çiftinin var olmayabilmesinden dolayı olabilir.

Yapı
^^^^

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Account ID", "id of the account to which the key-value information was set. If key-value pair doesnot exist , then it will be created", "an existing account", "artyom@soramitsu"
    "Key", "key of information being set", "`[A-Za-z0-9_]{1,64}`", "Name"
    "Value", "new value for the corresponding key", "length of value ≤ 4096", "Artyom"
    "Old value", "current value for the corresponding key", "length of value ≤ 4096", "Artem"

Onaylama
^^^^^^^^

Üç durum:

    Durum 1. İşlem yaratıcı hesabında hesap detayını ayarlamak isterken ve GetMyAccountDetail / GetAllAccountsDetail / GetDomainAccountDetail yetkilerine sahipken

    Durum 2. İşlem yaratıcı başka bir hesapta hesap detayını ayarlamak isterken ve SetAccountDetail ve GetAllAccountsDetail / GetDomainAccountDetail yetkilerine sahipken

    Durum 3. SetAccountDetail yetkisi işlem yaratıcıya verildi ve GetAllAccountsDetail / GetDomainAccountDetail yetkisine sahip

Muhtemel Durumsal Onaylama Hataları
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not compare and set account detail", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Command's creator does not have permission to set and read account detail for this account", "Grant the necessary permission"
    "3", "No such account", "Cannot find account to set account detail to", "Make sure account id is correct"
    "4", "No match values", "Old values do not match", "Make sure old value is correct"

Ayar değerini ayarlamak
-----------------------

Amaç
^^^^

Ayar değerini ayarlamak komutunun amacı ihtiyaçlarınıza göre kişiselleştirmeyi etkinleştirmektir.


Şema
^^^^

.. code-block:: proto

    message SetSettingValue {
        string key = 1;
        string value = 2;
    }

Yapı
^^^^

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Key", "Key of the setting", "list of possible settings", "MaxDescriptionSize"
    "Value", "Value of the setting", "type of setting", "255"


Onaylama
^^^^^^^^

1. Komut sadece genesis bloktan uygulanabilir

Muhtemel ayarların listesi
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
    :header: "Key", "Value constraint", "Description"

    "MaxDescriptionSize", "Unsigned integer, 0 <= MaxDescriptionSize < 2^32", "Maximum transaction description length"
