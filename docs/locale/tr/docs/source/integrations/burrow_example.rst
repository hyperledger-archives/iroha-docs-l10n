HL Burrow EVM'nin Nasıl Kullanıldığına Dair Örnekler
====================================================

Bu bölüm nasıl dağıtılacağına dair birkaç örnek ve Iroha blokzincirinin üstünde bir EVM'de akıllı sözleşme çalıştırmayı gösterir.

Iroha ile etkileşime geçmek için, bir `Python Iroha kullanıcısını <https://iroha.readthedocs.io/en/master/getting_started/python-guide.html>`_ kullanacağız. Iroha düğümü 50051 yerel bağlantı noktasını dinliyor varsayalım, kullanıcı kodu şunun gibi birşey olacak:

.. code-block:: python

	import os
	from iroha import Iroha, IrohaCrypto, IrohaGrpc

	iroha = Iroha('admin@test')
	net = IrohaGrpc('127.0.0.1:50051')

	admin_key = os.getenv(ADMIN_PRIVATE_KEY, IrohaCrypto.private_key())
	# Code for preparing and sending transaction

Durum 1. Hesaplama çalıştırmak ve veri depolamak
------------------------------------------------

İlk örnek olarak Solidity dökümantasyonundan `Subcurrency <https://solidity.readthedocs.io/en/latest/introduction-to-smart-contracts.html#subcurrency-example>`_ akıllı sözleşmesi alacağız.
Sözleşme kodu aşağıdaki şekildedir (okuyucu sözleşme kodunun her satırının ne anlama geldiğini anlamak için orijinal dökümantasyona başvurabilir, eğer gerekliyse):

.. code-block:: solidity

    contract Coin {
        // The keyword "public" makes variables
        // accessible from other contracts
        address public minter;
        mapping (address => uint) public balances;

        // Events allow clients to react to specific
        // contract changes you declare
        event Sent(address from, address to, uint amount);

        // Constructor code is only run when the contract
        // is created
        constructor() public {
            minter = msg.sender;
        }

        // Sends an amount of newly created coins to an address
        // Can only be called by the contract creator
        function mint(address receiver, uint amount) public {
            require(msg.sender == minter);
            require(amount < 1e60);
            balances[receiver] += amount;
        }

        // Sends an amount of existing coins
        // from any caller to an address
        function send(address receiver, uint amount) public {
            require(amount <= balances[msg.sender], "Insufficient balance.");
            balances[msg.sender] -= amount;
            balances[receiver] += amount;
            emit Sent(msg.sender, receiver, amount);
        }
    }

Başlamak için bayt kodunun üstündeki kaynak kodunu derlemeye ihtiyaç duyarız.
Bunun için tam teşekküllü Solidity derleyicisini veya web tabanlı *Remix IDE*'i kullanabiliriz.
Bayt kodunu aldıktan sonra, EVM'ye sözleşmeyi dağıtacak olan Python Iroha kullanıcısından bir işlem gönderebiliriz:

.. code-block:: python

	import os
	from iroha import Iroha, IrohaCrypto, IrohaGrpc

	iroha = Iroha('admin@test')
	net = IrohaGrpc('127.0.0.1:50051')

	admin_key = os.getenv(ADMIN_PRIVATE_KEY, IrohaCrypto.private_key())
	bytecode = ("608060405234801561001057600080fd5b50336000806101000a81548173ffff”
	            "ffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffff"
	            ...
	            "030033")

	tx = iroha.transaction([
	    iroha.command('CallEngine', caller='admin@energy', input=bytecode)
	])
	IrohaCrypto.sign_transaction(tx, admin_key)

	net.send_tx(tx)
	for status in net.tx_status_stream(tx):
	    print(status)


Bu sözleşmenin mint metodunu çağırmak için, metod seçiciyi içeren girdi parametresiyle aynı *CallEngine* komutunu göndeririz - fonksiyon imzasının *keccak256* karışımının ilk 4 baytı:

``keccak256(‘mint(address,uint256)’) == ‘40c10f19’``

sözleşme ABI kurallarına göre kodlanmış fonksiyon argümanları ile birleştirildi – ilk fonksiyon argümanı 20-bayt uzunluğunda bir tam sayı olan *address* tipine sahiptir.

Diyelim ki sözleşme sahibi (*admin@test* Iroha hesabı) 1000 coin mint istedi ve onları kendine atadı.
To get the EVM address corresponding to the *admin@test* using Python library we might use:

.. code-block:: python

	import sha3
	k = sha3.keccak_256()
	k.update(b'admin@test')
	print(hexlify(k.digest()[12:32]).zfill(64))

That way, we'll get:

``000000000000000000000000f205c4a929072dd6e7fc081c2a78dbc79c76070b``

So, the last 20 bytes are keccak256, zero left-padded to 32 bytes.


*amount* argümanı onaltılık olarak kodlanmış bir *uint256* sayısıdır  (ayrıca, sola dayalı):

``00000000000000000000000000000000000000000000000000000000000003e8``

Tüm argümanlar dizesi yukarıda birlikte zincirlenmiş üç parçanın birleşimidir.


Hepsini bir araya koyarak, *Coin* sözleşmesinin *mint* fonksiyonunu çağırmak için aşağıdaki müşteri kodunu alacağız:

.. code-block:: python

	import os
	from iroha import Iroha, IrohaCrypto, IrohaGrpc

	iroha = Iroha('admin@test')
	net = IrohaGrpc('127.0.0.1:50051')

	admin_key = os.getenv(ADMIN_PRIVATE_KEY, IrohaCrypto.private_key())
	params = ("40c10f19”                                                             # selector
	          "000000000000000000000000f205c4a929072dd6e7fc081c2a78dbc79c76070b"  # address
	          "00000000000000000000000000000000000000000000000000000000000003e8"  # amount
	         )

	tx = iroha.transaction([
	    iroha.command('CallEngine', callee='ServiceContract', input=params)
	])
	IrohaCrypto.sign_transaction(tx, admin_key)

	net.send_tx(tx)
	for status in net.tx_status_stream(tx):
	    print(status)

*send* fonksiyonunu çağırmak tamamen aynı yolla yapılır.

Daha önce açıklandığı gibi işlem geçmişinde kaydedilen bir Sent olayını yayan send fonksiyonunun son satırına dikkat edin:

.. code-block:: solidity

	emit Sent(msg.sender, receiver, amount);


Durum 2. Iroha'nın durumunu sorgulamak
--------------------------------------

Daha öncesinde Iroha'nın durumu ile etkileşime geçmemiş bir sözleşme örneğine baktık.
Fakat, çoğu gerçek yaşam uygulamalarında biri Iroha blokzincirinin üstünde çalıştırmayı hayal edebilirdi (işlem işleme veya işlem ücretleri tahsil etme vb. özel iş mantığı gibi) Iroha durumu ile etkileşime geçmek zorunludur.
Bu bölümde bir EVM akıllı sözleşmesinin içinden Iroha hesaplarının bakiyelerinin nasıl sorgulanabileceğine dair örnek düşüneceğiz (sorgu yaratıcının ilgili izinleri varsa).


Sözleşmenin kodu aşağıdaki diyagramda sunulmuştur:

.. code-block:: solidity

	contract QueryIroha {
	    address public serviceContractAddress;

	    // Initializing service contract address in constructor
	    constructor() public {
	        serviceContractAddress = 0xA6Abc17819738299B3B2c1CE46d55c74f04E290C;
	    }

	    // Queries the balance in _asset of an Iroha _account
	    function queryBalance(string memory _account, string memory _asset) public
	                    returns (bytes memory result) {
	        bytes memory payload = abi.encodeWithSignature(
	            "getAssetBalance(string,string)",
	            _account,
	            _asset);
	        (bool success, bytes memory ret) =
	            address(serviceContractAddress).delegatecall(payload);
	        require(success, "Error calling service contract function");
	        result = ret;
	    }
	}

Constructor'da Iroha durumuyla etkileşime geçmek için bir API gösteren `ServiceContract <burrow.html#running-native-iroha-commands-in-evm>`_'ın EVM adresini başlattık.
Sözleşme fonksiyonu *queryBalance*, Iroha *ServiceContract* API'ının *getAssetBalance* metodunu çağırır.

Durum 3. Iroha'nın durumunu değiştirme
--------------------------------------

Son örnekte bir Iroha hesabından ötekine bir varlığın transfer edilmesini düşünüyoruz.


Sözleşme kodu aşağıdaki gibidir:

.. code-block:: solidity

	contract Transfer {
	    address public serviceContractAddress;

	    event Transferred(string indexed source, string indexed destination, string amount);

	    // Initializing service contract address in constructor
	    constructor() public {
	        serviceContractAddress = 0xA6Abc17819738299B3B2c1CE46d55c74f04E290C;
	    }

	    // Queries the balance in _asset of an Iroha _account
	    function transferAsset(string memory src, string memory dst,
	                           string memory asset, string memory amount) public
	                    returns (bytes memory result) {
	        bytes memory payload = abi.encodeWithSignature(
	            "transferAsset(string,string,string,string)",
	            src,
	            dst,
	            asset,
	            amount);
	        (bool success, bytes memory ret) =
	            address(serviceContractAddress).delegatecall(payload);
	        require(success, "Error calling service contract function");

	        emit Transferred(src, dst, amount);
	        result = ret;
	    }
	}


Iroha'nın durumunu sorgulamaya benzer bir şekilde, bir komut ikincisini değiştirmek için gönderilebilir.
Üstteki örnekte `ServiceContract <burrow.html#running-native-iroha-commands-in-evm>`_'ın API metodu *transferAssetBalance* Iroha hesabı *src*'den *dst* hesabına *varlığın* bir *miktarını* gönderdi. Elbette, eğer işlem yaratıcı bu işlemi yürütmek için yeterli izinlere sahipse.








