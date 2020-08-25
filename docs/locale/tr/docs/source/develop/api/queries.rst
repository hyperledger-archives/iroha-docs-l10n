Sorgular
========

Sorgu World State View'in belirli bir bölümüyle ilgili bir istektir — blokzincirinin son durumu.
Sorgu zincirin içeriklerini değiştiremez ve herhangi bir 
kullanıcıya hemen bir cevap döndürür alıcı eş sorguyu işledikten sonra.

Onaylama
^^^^^^^^

Tüm sorgular için onaylama şunları içerir:

- timestamp — geçmişten olmamalı (eş zamanından 24 saat önce) veya gelecekten (eş zamanına 5 dakika aralığı eklemek)
- signature of query creator — sorgu yaratıcının kimliğini kontrol etmek için kullanılır
- query counter — sorgu yaratıcısından her sonraki sorguyla arttırıldığını kontol etmek 
- roles — sorgu yaratıcısının rolüne bağlı olarak: sorgulanmak için uygun durum aralığı aynı hesapla, alandaki hesapla, bütün zincirle ilgili olabilir veya hiç izin verilmez

Motor Alındı Bilgisi
^^^^^^^^^^^^^^^^^^^^

Amaç
----

CallEngine komutunun alındı bilgisini geri almak.
Ethereum JSON RPC API'ının eth.GetTransactionReceipt API çağrısına benzerdir. 
EVM'in içinde hesaplamalar boyunca yaratılmış olay günlüğüne erişmeye izin verir.

İstek Şeması
------------

.. code-block:: proto

   message GetEngineReceipts{
    string tx_hash = 1;     // hex string
    }

İstek Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Transaction Hash", "hash of the transaction that has the CallEngine command", "hash in hex format", "5241f70cf3adbc180199c1d2d02db82334137aede5f5ed35d649bbbc75ab2634"

Cevap Şeması
------------

.. code-block:: proto

    message EngineReceiptsResponse {
        repeated EngineReceipt engine_receipt = 1;
    }
    message EngineReceipt {
        int32 command_index = 1;
        string caller = 2;
        oneof opt_to_contract_address {
            CallResult call_result = 3;
            string contract_address = 4;
        }
        repeated EngineLog logs = 5;
    }
    message EngineLog {
        string address = 1;     // hex string
        string data = 2;            // hex string
        repeated string topics = 3; // hex string
    }

Cevap Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Command Index", "Index of the CallEngine command in the transaction", "non-negative integer", "0"
    "Tx Hash", "Hash of the transaction that contained the CallEngine command", "hash in hex format", "5241f70cf3adbc180199c1d2d02db82334137aede5f5ed35d649bbbc75ab2634"
    "Tx Index", "Index of the transaction in the block", "non-negative integer", "3"
    "Block Hash", "Hash of the block that contains the transaction with CallEngine command", "hash in hex format", "bf85ed02c52f8aed04e88cca3ce4595000ca10fe7ab5e07fc96f1d005eb6bedc"
    "Block Height", "Block’s ordinal number in the chain", "non-negative integer", "19"
    "From", "Transaction sender account ID", "<account_name>@<domain_id>", "admin@test"
    "To", "EVM address of a contract - the Callee of the original CallEngine command", "20-bytes string in hex representation", "7C370993FD90AF204FD582004E2E54E6A94F2651"
    "Contract Address", "EVM address of a newly deployed contract", "20-bytes string in hex representation", "7C370993FD90AF204FD582004E2E54E6A94F2651"
    "Engine Log", "Array of EVM event logs created during smart contract execution. Each log entry is a tuple (Address, [Topic], Data), where Address is the contract caller EVM address, topics are 32-byte strings and Data is an arbitrary length byte array (in hex)", "From Ethereum Yellow Paper: Log entry O ≡ (Oa,(Ot0, Ot1, ...), Od), where Oa ∈ B20 ∧ ∀x ∈ Ot : x ∈ B32 ∧ Od ∈ B", "(577266A3CE7DD267A4C14039416B725786605FF4, [3990DB2D31862302A685E8086B5755072A6E2B5B780AF1EE81ECE35EE3CD3345, 000000000000000000000000969453762B0C739DD285B31635EFA00E24C25628], 0000000000000000000000007203DF5D7B4F198848477D7F9EE080B207E544DD000000000000000000000000000000000000000000000000000000000000006D)"


Muhtemel Durumsal Onaylama Hataları
-----------------------------------

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "2", "No such permissions", "Query’s creator does not have any of the permissions to get the call engine receipt", "Grant the necessary permission"
    "3", "Invalid signatures", "Signatures of this query did not pass validation", "Add more signatures and make sure query's signatures are a subset of account's signatories"

Hesap edinmek
^^^^^^^^^^^^^

Amaç
----

Hesap edinmek sorgusunun amacı bir hesabın durumunu almaktır.

İstek Şeması
------------

.. code-block:: proto

    message GetAccount {
        string account_id = 1;
    }

İstek Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Account ID", "account id to request its state", "<account_name>@<domain_id>", "alex@morgan"

Cevap Şeması
------------

.. code-block:: proto

    message AccountResponse {
        Account account = 1;
        repeated string account_roles = 2;
    }

    message Account {
        string account_id = 1;
        string domain_id = 2;
        uint32 quorum = 3;
        string json_data = 4;
    }


Cevap Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Account ID", "account id", "<account_name>@<domain_id>", "alex@morgan"
    "Domain ID", "domain where the account was created", "RFC1035 [#f1]_, RFC1123 [#f2]_ ", "morgan"
    "Quorum", "number of signatories needed to sign the transaction to make it valid", "0 < quorum ≤ 128", "5"
    "JSON data", "key-value account information", "JSON", "{ genesis: {name: alex} }"

Muhtemel Durumsal Onaylama Hataları
-----------------------------------

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not get account", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Query's creator does not have any of the permissions to get account", "Grant the necessary permission: individual, global or domain one"
    "3", "Invalid signatures", "Signatures of this query did not pass validation", "Add more signatures and make sure query's signatures are a subset of account's signatories"

Blok edinmek
^^^^^^^^^^^^

Amaç
----

Blok edinmek sorgusunun amacı yüksekliğini tanımlayıcı olarak kullanarak spesifik bir blok almaktır

İstek Şeması
------------

.. code-block:: proto

    message GetBlock {
      uint64 height = 1;
    }


İstek Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Height", "height of the block to be retrieved", "0 < height < 2^64", "42"

Cevap Şeması
------------

.. code-block:: proto

    message BlockResponse {
      Block block = 1;
    }

Cevap Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Block", "the retrieved block", "block structure", "block"

Muhtemel Durumsal Onaylama Hataları
-----------------------------------

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not get block", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Query's creator does not have a permission to get block", "Grant `can_get_block <permissions.html#can-get-blocks>`__ permission"
    "3", "Invalid signatures", "Signatures of this query did not pass validation", "Add more signatures and make sure query's signatures are a subset of account's signatories"
    "3", "Invalid height", "Supplied height is not uint_64 or greater than the ledger's height", "Check the height and try again"

.. not::
    Hata kodu 3 bu sorgu için belirsizdir.
    Geçersiz imza sahipleri veya geçersiz yüksekliği belirtir.
    Bu metodu geçersiz imza sahiperini kontrol etmek için `height = 1` ile kullanınız (ilk blok her zaman mevcuttur).

İmza sahibi edinmek
^^^^^^^^^^^^^^^^^^^

Amaç
----

İmza sahibi edinmek sorgusunun amacı hesabın kimliği olarak davranan imza sahibi edinmektir.

İstek Şeması
------------

.. code-block:: proto

    message GetSignatories {
        string account_id = 1;
    }

İstek Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Account ID", "account id to request signatories", "<account_name>@<domain_id>", "alex@morgan"

Cevap Şeması
------------

.. code-block:: proto

    message SignatoriesResponse {
        repeated bytes keys = 1;
    }

Cevap Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Keys", "an array of public keys", "`ed25519 <https://ed25519.cr.yp.to>`_", "292a8714694095edce6be799398ed5d6244cd7be37eb813106b217d850d261f2"

Muhtemel Durumsal Onaylama Hataları
-----------------------------------

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not get signatories", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Query's creator does not have any of the permissions to get signatories", "Grant the necessary permission: individual, global or domain one"
    "3", "Invalid signatures", "Signatures of this query did not pass validation", "Add more signatures and make sure query's signatures are a subset of account's signatories"

İşlemleri edinmek
^^^^^^^^^^^^^^^^^

Amaç
----

GetTransactions karışımlarını baz alarak işlemler hakkında bilgi geri almak için kullanılır.
.. not:: Bu sorgu ancak ve ancak bütün talep edilen karışımlar doğruysa geçerlidir: karşılık gelen işlemler var ve kullanıcı geri almak için yetkiye sahip 

İstek Şeması
------------

.. code-block:: proto

    message GetTransactions {
        repeated bytes tx_hashes = 1;
    }

İstek Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Transactions hashes", "an array of hashes", "array with 32 byte hashes", "{hash1, hash2…}"

Cevap Şeması
------------

.. code-block:: proto

    message TransactionsResponse {
        repeated Transaction transactions = 1;
    }

Cevap Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Transactions", "an array of transactions", "Committed transactions", "{tx1, tx2…}"

Muhtemel Durumsal Onaylama Hataları
-----------------------------------

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not get transactions", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Query's creator does not have any of the permissions to get transactions", "Grant the necessary permission: individual, global or domain one"
    "3", "Invalid signatures", "Signatures of this query did not pass validation", "Add more signatures and make sure query's signatures are a subset of account's signatories"
    "4", "Invalid hash", "At least one of the supplied hashes either does not exist in user's transaction list or creator of the query does not have permissions to see it", "Check the supplied hashes and try again"

Bekleme İşlemlerini Edinmek
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Amaç
----

GetPendingTransactions bekleyen (tam olarak imzalanmamış) `çoklu imza işlemlerinin <../../concepts_architecture/glossary.html#multisignature-transactions>`_ bir listesini geri almak için kullanılır
veya `toplu işlemler <../../concepts_architecture/glossary.html#batch-of-transactions>`__ sorgu yaratıcının hesabı tarafından yayınlandı.

.. not:: Bu sorgu daha hızlı ve daha uygun sorgu cevapları için sayfaları numaralamayı kullanır.

İstek Şeması
------------

.. code-block:: proto

    message TxPaginationMeta {
        uint32 page_size = 1;
        oneof opt_first_tx_hash {
            string first_tx_hash = 2;
        }
    }

    message GetPendingTransactions {
        TxPaginationMeta pagination_meta = 1;
    }

İstek Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Page size", "maximum amount of transactions returned in the response", "page_size > 0", "5"
    "First tx hash", "optional - hash of the first transaction in the starting batch", "hash in hex format", "bddd58404d1315e0eb27902c5d7c8eb0602c16238f005773df406bc191308929"

Bütün kullanıcıların yarı-imzalanmış çoklu imzalı (bekleyen) işlemleri sorgulanabilir.
Maksimum işlem miktarı **page_size** alanı tarafından sınırlandırılabilir bir cevap içerir.
Bütün bekleyen işlemler yeterli imza toplayana kadar depolanır  veya süresi dolmuştur.
Bekleyen işlemlerin ortak sırası veya toplu işlemler kullanıcı için korunur.
Kullanıcının sırayla tüm işlemleri sorgulamasını sağlar - sayfa sayfa.
Her yanıt sonraki toplu işleme veya sorgulanabilir bir işleme referans içerebilir.
Bir sayfa boyutu onu takip eden toplu işlemin boyutundan daha büyük olabilir (işlemlerde).
Bu durumda, birkaç toplu işlem veya işlemler geri döndürülecek.
Sayfalarda gezinme sırasında, sorgulamadan önce takip eden toplu işlem eksik imzaları toplayabilir.
Bu toplu işlemin eksik bir karışımından dolayı durumsal hatalı sorgu cevabına yok açacaktır.

Örnek
-----

Her biri üç işlem içeren iki bekleyen toplu işlem varsa ve bir kullanıcı sayfa boyutu 5 olan 
bekleyen işlemleri sorgularsa ilk toplu işin işlemleri cevaptadır ve ikinci toplu işe referans da 
belirtilecektir (ilk aslında tek bir işlem olsa bile işlem karışımı ve toplu iş boyutu)
İkinci toplu işin işlemleri ilk yanıtta bulunmaz çünkü toplu iş birkaç parçaya bölünemez ve bir 
yanıtta sadece tam toplu işler bulunabilir 

Cevap Şeması
------------

.. code-block:: proto

    message PendingTransactionsPageResponse {
        message BatchInfo {
            string first_tx_hash = 1;
            uint32 batch_size = 2;
        }
        repeated Transaction transactions = 1;
        uint32 all_transactions_size = 2;
        BatchInfo next_batch_info = 3;
    }

Cevap Yapısı
------------

Bir cevap `bekleyen işlemlerin <../../concepts_architecture/glossary.html#pending-transactions>`_ listesini içerir,
kullanıcı için bütün depolanmış bekleyen işlemlerin miktarı
ve bilgi sonraki sayfayı sorgulamak için gereklidir (eğer varsa).

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

        "Transactions", "an array of pending transactions", "Pending transactions", "{tx1, tx2…}"
        "All transactions size", "the number of stored transactions", "all_transactions_size >= 0", "0"
        "Next batch info", "A reference to the next page - the message might be not set in a response", "", ""
        "First tx hash", "hash of the first transaction in the next batch",  "hash in hex format", "bddd58404d1315e0eb27902c5d7c8eb0602c16238f005773df406bc191308929"
        "Batch size", "Minimum page size required to fetch the next batch", "batch_size > 0", "3"

Bekleyen işlemler edinmek (kullanımdan kaldırılmış)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. uyarı::
  Parametresiz sorgular kullanımdan kaldırıldı ve sonraki büyük Iroha sürümünde (2.0) kaldırılacak.
  Lütfen `Get Pending Transactions <#get-pending-transactions>`__ yerine yeni sorgu versiyonunu kullanın.

Amaç
----

GetPendingTransactions bekleyen (tam olarak imzalanmamış) `çok imzalı işlemlerin <../../concepts_architecture/glossary.html#multisignature-transactions>`_ 
bir listesini geri almak için kullanılır
veya `toplu işlemlerde <../../concepts_architecture/glossary.html#batch-of-transactions>`__ sorgu yaratıcının hesabı tarafından yayınlandı.

İstek Şeması
------------

.. code-block:: proto

    message GetPendingTransactions {
    }

Cevap Şeması
------------

.. code-block:: proto

    message TransactionsResponse {
        repeated Transaction transactions = 1;
    }

Cevap Yapısı
------------

Cevap `bekleyen işlemlerin <../../concepts_architecture/glossary.html#pending-transactions>`_ bir listesini içerir.

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

        "Transactions", "an array of pending transactions", "Pending transactions", "{tx1, tx2…}"

Muhtemel Durumsal Onaylama Hataları
-----------------------------------

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not get pending transactions", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Query's creator does not have any of the permissions to get pending transactions", "Grant the necessary permission: individual, global or domain one"
    "3", "Invalid signatures", "Signatures of this query did not pass validation", "Add more signatures and make sure query's signatures are a subset of account's signatories"

Hesap İşlemlerini Edinmek
^^^^^^^^^^^^^^^^^^^^^^^^^

Amaç
----

Bir durumda hesap başına işlemlerin listesine ihtiyaç duyulduğunda, `GetAccountTransactions` sorgusu oluşturulabilir.

.. not:: Bu sorgu daha hızlı ve daha uygun sorgu cevapları için sayfaları numaralamayı kullanır.

İstek Şeması
------------

.. code-block:: proto

    message TxPaginationMeta {
        uint32 page_size = 1;
        oneof opt_first_tx_hash {
            string first_tx_hash = 2;
        }
    }

    message GetAccountTransactions {
        string account_id = 1;
        TxPaginationMeta pagination_meta = 2;
    }

İstek Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Account ID", "account id to request transactions from", "<account_name>@<domain_id>", "makoto@soramitsu"
    "Page size", "size of the page to be returned by the query, if the response contains fewer transactions than a page size, then next tx hash will be empty in response", "page_size > 0", "5"
    "First tx hash", "hash of the first transaction in the page. If that field is not set — then the first transactions are returned", "hash in hex format", "bddd58404d1315e0eb27902c5d7c8eb0602c16238f005773df406bc191308929"

Cevap Şeması
------------

.. code-block:: proto

    message TransactionsPageResponse {
        repeated Transaction transactions = 1;
        uint32 all_transactions_size = 2;
        oneof next_page_tag {
            string next_tx_hash = 3;
        }
    }

Muhtemel Durumsal Onaylama Hataları
-----------------------------------

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not get account transactions", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Query's creator does not have any of the permissions to get account transactions", "Grant the necessary permission: individual, global or domain one"
    "3", "Invalid signatures", "Signatures of this query did not pass validation", "Add more signatures and make sure query's signatures are a subset of account's signatories"
    "4", "Invalid pagination hash", "Supplied hash does not appear in any of the user's transactions", "Make sure hash is correct and try again"
    "5", "Invalid account id", "User with such account id does not exist", "Make sure account id is correct"

Cevap Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Transactions", "an array of transactions for given account", "Committed transactions", "{tx1, tx2…}"
    "All transactions size", "total number of transactions created by the given account", "", "100"
    "Next transaction hash", "hash pointing to the next transaction after the last transaction in the page. Empty if a page contains the last transaction for the given account", "bddd58404d1315e0eb27902c5d7c8eb0602c16238f005773df406bc191308929"

Hesap varlık işlemleri edinmek
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Amaç
----

`GetAccountAssetTransactions` sorgusu verilen hesap ve varlık ile ilişkili bütün işlemleri geri döndürür.

.. not:: Bu sorgu sorgu cevapları için sayfaları numaralamayı kullanır.

İstek Şeması
------------

.. code-block:: proto

    message TxPaginationMeta {
        uint32 page_size = 1;
        oneof opt_first_tx_hash {
            string first_tx_hash = 2;
        }
    }

    message GetAccountAssetTransactions {
        string account_id = 1;
        string asset_id = 2;
        TxPaginationMeta pagination_meta = 3;
    }

İstek Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Account ID", "account id to request transactions from", "<account_name>@<domain_id>", "makoto@soramitsu"
    "Asset ID", "asset id in order to filter transactions containing this asset", "<asset_name>#<domain_id>", "jpy#japan"
    "Page size", "size of the page to be returned by the query, if the response contains fewer transactions than a page size, then next tx hash will be empty in response", "page_size > 0", "5"
    "First tx hash", "hash of the first transaction in the page. If that field is not set — then the first transactions are returned", "hash in hex format", "bddd58404d1315e0eb27902c5d7c8eb0602c16238f005773df406bc191308929"

Cevap Şeması
------------

.. code-block:: proto

    message TransactionsPageResponse {
        repeated Transaction transactions = 1;
        uint32 all_transactions_size = 2;
        oneof next_page_tag {
            string next_tx_hash = 3;
        }
    }

Cevap Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Transactions", "an array of transactions for given account and asset", "Committed transactions", "{tx1, tx2…}"
    "All transactions size", "total number of transactions for given account and asset", "", "100"
    "Next transaction hash", "hash pointing to the next transaction after the last transaction in the page. Empty if a page contains the last transaction for given account and asset", "bddd58404d1315e0eb27902c5d7c8eb0602c16238f005773df406bc191308929"

Muhtemel Durumsal Onaylama Hataları
-----------------------------------

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not get account asset transactions", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Query's creator does not have any of the permissions to get account asset transactions", "Grant the necessary permission: individual, global or domain one"
    "3", "Invalid signatures", "Signatures of this query did not pass validation", "Add more signatures and make sure query's signatures are a subset of account's signatories"
    "4", "Invalid pagination hash", "Supplied hash does not appear in any of the user's transactions", "Make sure hash is correct and try again"
    "5", "Invalid account id", "User with such account id does not exist", "Make sure account id is correct"
    "6", "Invalid asset id", "Asset with such asset id does not exist", "Make sure asset id is correct"

Hesap varlıkları edinmek
^^^^^^^^^^^^^^^^^^^^^^^^

Amaç
----

Bir hesaptaki bütün varlıkların durumunu öğrenmek için (bakiye), `GetAccountAssets` sorgusu kullanılabilir.

İstek Şeması
------------

.. code-block:: proto

    message AssetPaginationMeta {
        uint32 page_size = 1;
        oneof opt_first_asset_id {
            string first_asset_id = 2;
        }
    }

    message GetAccountAssets {
        string account_id = 1;
        AssetPaginationMeta pagination_meta = 2;
    }

İstek Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Account ID", "account id to request balance from", "<account_name>@<domain_id>", "makoto@soramitsu"
    AssetPaginationMeta.page_size, "Requested page size. The number of assets in response will not exceed this value. If the response was truncated, the asset id immediately following the returned ones will be provided in next_asset_id.", 0 < page_size < 32 bit unsigned int max (4294967296), 100
    AssetPaginationMeta.first_asset_id, "Requested page start.  If the field is not set, then the first page is returned.", name#domain, my_asset#my_domain

Cevap Şeması
------------
.. code-block:: proto

    message AccountAssetResponse {
        repeated AccountAsset account_assets = 1;
        uint32 total_number = 2;
        oneof opt_next_asset_id {
            string next_asset_id = 3;
        }
    }

    message AccountAsset {
        string asset_id = 1;
        string account_id = 2;
        string balance = 3;
    }

Cevap Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Asset ID", "identifier of asset used for checking the balance", "<asset_name>#<domain_id>", "jpy#japan"
    "Account ID", "account which has this balance", "<account_name>@<domain_id>", "makoto@soramitsu"
    "Balance", "balance of the asset", "No less than 0", "200.20"
    total_number, number of assets matching query without page limits, 0 < total_number < 32 bit unsigned int max (4294967296), 100500
    next_asset_id, the id of asset immediately following curent page, name#domain, my_asset#my_domain

.. not::
   Eğer sayfa boyutu istenen diğer kriterlerle eşleşen varlıkların sayısından eşit veya büyükse, sonraki varlık id'si cevapta ayarlanmayacaktır.
   Aksi takdirde, bir sonraki sayfayı getirmek istiyorlarsa kullanıcıların ilk varlık id'si için kullanması gereken değeri içerir.


Muhtemel Durumsal Onaylama Hataları
-----------------------------------

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not get account assets", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Query's creator does not have any of the permissions to get account assets", "Grant the necessary permission: individual, global or domain one"
    "3", "Invalid signatures", "Signatures of this query did not pass validation", "Add more signatures and make sure query's signatures are a subset of account's signatories"
    "4", "Invalid pagination metadata", "Wrong page size or nonexistent first asset", "Set a valid page size, and make sure that asset id is valid, or leave first asset id unspecified"

Hesap Detaylarını Edinmek
^^^^^^^^^^^^^^^^^^^^^^^^^

Amaç
----

Hesabın detaylarını öğrenmek için, `GetAccountDetail` sorgusu kullanılabilir. Hesap detayları yazar kategorilerine ayrılmış anahtar-değer çiftleridir. Yazarlar karşılık gelen hesap detayına eklenmiş hesaplardır. Böyle bir yapının örneği olarak:

.. code-block:: json

    {
        "account@a_domain": {
            "age": 18,
            "hobbies": "crypto"
        },
        "account@b_domain": {
            "age": 20,
            "sports": "basketball"
        }
    }

Burada, dört hesap detayı görülebilir - "age", "hobbies" ve "sports" - iki yazar tarafından eklenmiş - "account@a_domain" ve "account@b_domain". Bu detayların tamamı açık olarak aynı hesap hakkındadır.

İstek Şeması
------------

.. code-block:: proto

    message AccountDetailRecordId {
      string writer = 1;
      string key = 2;
    }

    message AccountDetailPaginationMeta {
      uint32 page_size = 1;
      AccountDetailRecordId first_record_id = 2;
    }

    message GetAccountDetail {
      oneof opt_account_id {
        string account_id = 1;
      }
      oneof opt_key {
        string key = 2;
      }
      oneof opt_writer {
        string writer = 3;
      }
      AccountDetailPaginationMeta pagination_meta = 4;
    }

.. not::
    Dikkat, sayfalandırma metası hariç bütün alanlar opsiyoneldir.
    Bunun nedenleri aşağıda açıklanmıştır.

.. uyarı::
    Sayfalandırma metaverisi uyumluluk nedeniyle istekte eksik olabilir fakat bu davranış kullanımdan kaldırıldı ve kaçınılmalıdır.

İstek Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

        "Account ID", "account id to get details from", "<account_name>@<domain_id>", "account@domain"
        "Key", "key, under which to get details", "string", "age"
        "Writer", "account id of writer", "<account_name>@<domain_id>", "account@domain"
        AccountDetailPaginationMeta.page_size, "Requested page size. The number of records in response will not exceed this value. If the response was truncated, the record id immediately following the returned ones will be provided in next_record_id.", 0 < page_size < 32 bit unsigned int max (4294967296), 100
        AccountDetailPaginationMeta.first_record_id.writer, requested page start by writer, name#domain, my_asset#my_domain
        AccountDetailPaginationMeta.first_record_id.key, requested page start by key, string, age

.. not::
    İlk kayıt id'sini belirtirken, ana sorguda ayarlanmamış nitelikleri (yazar, anahtar) sağlamak yeterlidir.

İstek Şeması
------------

.. code-block:: proto

    message AccountDetailResponse {
      string detail = 1;
      uint64 total_number = 2;
      AccountDetailRecordId next_record_id = 3;
    }

İstek Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

        "Detail", "key-value pairs with account details", "JSON", "see below"
        total_number, number of records matching query without page limits, 0 < total_number < 32 bit unsigned int max (4294967296), 100
        next_record_id.writer, the writer account of the record immediately following curent page, <account_name>@<domain_id>, pushkin@lyceum.tsar
        next_record_id.key, the key of the record immediately following curent page, string, "cold and sun"

Muhtemel Durumsal Onaylama Hataları
-----------------------------------

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not get account detail", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Query's creator does not have any of the permissions to get account detail", "Grant the necessary permission: individual, global or domain one"
    "3", "Invalid signatures", "Signatures of this query did not pass validation", "Add more signatures and make sure query's signatures are a subset of account's signatories"
    "4", "Invalid pagination metadata", "Wrong page size or nonexistent first record", "Set valid page size, and make sure that the first record id is valid, or leave the first record id unspecified"

Kullanım Örnekleri
------------------

Tekrar, baştan detayların örneklerini düşünelim ve `GetAccountDetail` sorgularının farklı varyantlarının sonuçta ortaya çıkan cevabı nasıl değiştirdiğini görelim.

.. code-block:: json

    {
        "account@a_domain": {
            "age": 18,
            "hobbies": "crypto"
        },
        "account@b_domain": {
            "age": 20,
            "sports": "basketball"
        }
    }

**account_id is not set**

Eğer account_id ayarlanmadıysa - diğer alanlar boş olabilir veya olmayabilir - Otomatik olarak sonraki durumlardan birine yol açacak sorgu yaratıcının hesabıyla değiştirilecektir.

**only account_id is set**

Bu durumda, hesap hakkındaki bütün detaylar geri döndürülür, aşağıdaki yanıta yol açar:

.. code-block:: json

    {
        "account@a_domain": {
            "age": 18,
            "hobbies": "crypto"
        },
        "account@b_domain": {
            "age": 20,
            "sports": "basketball"
        }
    }

**account_id and key are set**

Burada, anahtarın altındaki tüm yazarlar tarafından eklenen ayrıntılar geri döndürülecektir. Örneğin, eğer "age" anahtarını sorsaydık, alacağımız cevap budur:

.. code-block:: json

    {
        "account@a_domain": {
            "age": 18
        },
        "account@b_domain": {
            "age": 20
        }
    }

**account_id and writer are set**

Şimdi, cevap spesifik bir yazar tarafından eklenen bu hesap hakkında bütün detayları içerecek. Örneğin, eğer "account@b_domain" yazarını sorarsak, şununla karşılaşacağız:

.. code-block:: json

    {
        "account@b_domain": {
            "age": 20,
            "sports": "basketball"
        }
    }

**account_id, key and writer are set**

Sonuç olarak, her üç alan da ayarlanmışsa, sonuç spesifik bir yazarı ekleyen ve spesifik bir anahtarın altındaki detayları içerecek, örneğin, eğer "age" anahtarını sorsaydık ve yazar "account@a_domain" ise, şununla karşılaşacağız:

.. code-block:: json

    {
        "account@a_domain": {
            "age": 18
        }
    }

Varlık Bilgisi Edinmek
^^^^^^^^^^^^^^^^^^^^^^

Amaç
----

Verilen varlıktaki bilgiyi elde etmek için (şimdilik - hassasiyeti), kullanıcı `GetAssetInfo` sorgusunu gönderebilir.

İstek Şeması
------------

.. code-block:: proto

    message GetAssetInfo {
        string asset_id = 1;
    }

İstek Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Asset ID", "asset id to know related information", "<asset_name>#<domain_id>", "jpy#japan"


Cevap Şeması
------------

.. code-block:: proto

    message Asset {
        string asset_id = 1;
        string domain_id = 2;
        uint32 precision = 3;
    }

.. not::
    Bilinen bir sorundan dolayı geçersiz kesinlik değeri geçerseniz herhangi bir kural dışı işlem uyarısı alamayacağınızı lütfen unutmayın.
    Geçerli aralık: 0 <= hassasiyet <= 255

Muhtemel Durumsal Onaylama Hataları
-----------------------------------

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not get asset info", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Query's creator does not have any of the permissions to get asset info", "Grant the necessary permission: individual, global or domain one"
    "3", "Invalid signatures", "Signatures of this query did not pass validation", "Add more signatures and make sure query's signatures are a subset of account's signatories"

Cevap Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Asset ID", "identifier of asset used for checking the balance", "<asset_name>#<domain_id>", "jpy#japan"
    "Domain ID", "domain related to this asset", "RFC1035 [#f1]_, RFC1123 [#f2]_", "japan"
    "Precision", "number of digits after comma", "0 <= precision <= 255", "2"

Rol Edinmek
^^^^^^^^^^^

Amaç
----

Sistemde var olan rollere erişmek için, bir kullanıcı Iroha ağına `GetRoles` sorgusu gönderebilir.

İstek Şeması
------------

.. code-block:: proto

    message GetRoles {
    }

Cevap Şeması
------------

.. code-block:: proto

    message RolesResponse {
        repeated string roles = 1;
    }

Cevap Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Roles", "array of created roles in the network", "set of roles in the system", "{MoneyCreator, User, Admin, …}"

Muhtemel Durumsal Onaylama Hataları
-----------------------------------

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not get roles", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Query's creator does not have any of the permissions to get roles", "Grant the necessary permission: individual, global or domain one"
    "3", "Invalid signatures", "Signatures of this query did not pass validation", "Add more signatures and make sure query's signatures are a subset of account's signatories"

Rol yetkilerini edinmek
^^^^^^^^^^^^^^^^^^^^^^^

Amaç
----

Sistemdeki rol başına kullanılabilir izinleri almak için, bir kullanıcı Iroha ağına `GetRolePermissions` sorgusunu gönderebilir.

İstek Şeması
------------

.. code-block:: proto

    message GetRolePermissions {
        string role_id = 1;
    }

İstek Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Role ID", "role to get permissions for", "existing role in the system", "MoneyCreator"

Cevap Şeması
------------

.. code-block:: proto

    message RolePermissionsResponse {
        repeated string permissions = 1;
    }

Cevap Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Permissions", "array of permissions related to the role", "string of permissions related to the role", "{can_add_asset_qty, …}"

Muhtemel Durumsal Onaylama Hataları
-----------------------------------

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not get role permissions", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Query's creator does not have any of the permissions to get role permissions", "Grant the necessary permission: individual, global or domain one"
    "3", "Invalid signatures", "Signatures of this query did not pass validation", "Add more signatures and make sure query's signatures are a subset of account's signatories"

.. [#f1] https://www.ietf.org/rfc/rfc1035.txt
.. [#f2] https://www.ietf.org/rfc/rfc1123.txt


Eşleri edinmek
^^^^^^^^^^^^^^

Amaç
----

Iroha ağında eşlerin bir listesini geri döndüren bir sorgudur.

İstek Şeması
------------

.. code-block:: proto

    message GetPeers {
    }

Cevap Şeması
------------

.. code-block:: proto

    message Peer {
      string address = 1;
      string peer_key = 2; // hex string
    }

    message PeersResponse {
      repeated Peer peers = 1;
    }

Cevap Yapısı
------------

Adresleriyle ve genel anahtarlarıyla eşlerin bir listesini geri döndürür.

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Peers", "array of peers from the network", "non-empty list of peers", "{Peer{""peer.domain.com"", ""292a8714694095edce6be799398ed5d6244cd7be37eb813106b217d850d261f2""}, …}"

Muhtemel Durumsal Onaylama Hataları
-----------------------------------

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not get peers", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Query creator does not have enough permissions to get peers", "Append a role with can_get_blocks or can_get_peers permission"
    "3", "Invalid signatures", "Signatures of this query did not pass validation", "Add more signatures and make sure query's signatures are a subset of account's signatories"

.. uyarı::

    Şu anda eşleri edinmek sorgusu uyumluluk amacıyla "can_get_blocks" yetkisini kullanır.
    Daha sonra sonraki büyük Iroha sürümüyle birlikte "can_get_peers" olarak değiştirilecek.

İşlemeleri getirmek
^^^^^^^^^^^^^^^^^^^

Amaç
----

İşlendikleri anda yeni bloklar edinmek, bir kullanıcı Iroha ağına `FetchCommits` RPC çağrısı çağırabilir.

İstek Şeması
------------

İstek argümanına ihtiyaç duyulmuyor


Cevap Şeması
------------

.. code-block:: proto

    message BlockQueryResponse {
      oneof response {
        BlockResponse block_response = 1;
        BlockErrorResponse block_error_response = 2;
      }
    }

    message BlockResponse {
      Block block = 1;
    }

    message BlockErrorResponse {
      string message = 1;
    }

Lütfen `BlockQueryResponse` akışı geri döndürdüğünü unutmayın.

Cevap Yapısı
------------

.. csv-table::
    :header: "Field", "Description", "Constraint", "Example"
    :widths: 15, 30, 20, 15

    "Block", "Iroha block", "only committed blocks", "{ 'block_v1': ....}"

Muhtemel Durumsal Onaylama Hataları
-----------------------------------

.. csv-table::
    :header: "Code", "Error Name", "Description", "How to solve"

    "1", "Could not get block streaming", "Internal error happened", "Try again or contact developers"
    "2", "No such permissions", "Query's creator does not have any of the permissions to get blocks", "Grant `can_get_block <permissions.html#can-get-blocks>`__ permission"
    "3", "Invalid signatures", "Signatures of this query did not pass validation", "Add more signatures and make sure query's signatures are a subset of account's signatories"

.. not::
    `BlockErrorResponse` sadece `message` alanını içerir.
    Durumsal doğrulama hatası durumunda "durumsal geçersizlik" olacaktır.
    `GetBlock <#get-block>`__ aynı `can_get_block <permissions.html#can-get-blocks>`__ yetkisini gerektirir.
    Bu nedenle, geçersiz imza sahiplerini veya yetersiz yetkilerini kontrol etmek için `height = 1` ile kullanılabilir (ilk blok her zaman mevcuttur).

Örnek
-----
Bu sorgunun nasıl kullanılacağına dair bir örneği burada kontrol edebilirsiniz:
https://github.com/x3medima17/twitter

