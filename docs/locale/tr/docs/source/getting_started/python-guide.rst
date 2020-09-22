Python kütüphanesi ile işlemleri göndermek
==========================================

Önkoşullar
----------

.. note:: The library only works in Python 3 environment (Python 2 is not supported).

Iroha Python kütüphanesini kullanmak için, `depodan <https://github.com/hyperledger/iroha-python>`_
onu almanız gerekir ve pip3 aracılığıyla:

.. code-block:: shell

	pip3 install iroha

Creating your own key pairs with Python library
-----------------------------------------------

For testing purposes, you can use example keys.
But you can also create your own.
To create **native Iroha ed25519 SHA-3** keys (difference between algorithms can be found `here <../develop/keys.html>`__), please use the following code:

.. code-block:: python

	from iroha import IrohaCrypto

	# these first two lines are enough to create the keys
	private_key = IrohaCrypto.private_key()
	public_key = IrohaCrypto.derive_public_key(private_key)

	# the rest of the code writes them into the file
	with open('keypair.priv', 'wb') as f:
	    f.write(private_key)

	with open('keypair.pub', 'wb') as f:
	    f.write(public_key)

And for HL Ursa ed25519 SHA-2 keys in Multihash format, please use:

.. code-block:: python

	from iroha import IrohaCrypto, ed25519_sha2
	from nacl.encoding import HexEncoder

	private_key = ed25519_sha2.SigningKey.generate()
	public_key = IrohaCrypto.derive_public_key(private_key).encode('ascii')

	with open('keypair.priv', 'wb') as f:
	    f.write(private_key.encode(encoder=HexEncoder))
	    f.write(public_key[6:])

	with open('keypair.pub', 'wb') as f:
	    f.write(public_key)


Now, as we have the library and the keys, we can start sending the actual transactions.

Örnek işlemleri çalıştırma
--------------------------

Eğer sadece Iroha işlemlerinin nasıl görüneceğini denemek istiyorsanız,
`Buradan <https://github.com/hyperledger/iroha-python/tree/master/examples>`_
basitçe depodaki örneklere gidebilirsiniz.
`tx-example.py` dosyasını kontrol edelim.

İşte Iroha bağımlılıkları.
Python kütüphanesi genellikle içeri aktarmamız gereken 3 bölümden oluşur: Iroha, IrohaCrypto ve IrohaGrpc:

.. code-block:: python

	from iroha import Iroha, IrohaGrpc
	from iroha import IrohaCrypto

Satır

.. code-block:: python

	from iroha.primitive_pb2 import can_set_my_account_detail


aslında işlem için kullanabileceğiniz izinler hakkındadır.
Tam listeyi buradan bulabilirsiniz: `İzinler <../develop/api/permissions.html>`_.


Bir sonraki blokta aşağıdakileri görebiliriz:

.. code-block:: python

	admin_private_key = 'f101537e319568c765b2cc89698325604991dca57b9716b58016b253506cab70'
	user_private_key = IrohaCrypto.private_key()
	user_public_key = IrohaCrypto.derive_public_key(user_private_key)
	iroha = Iroha('admin@test')
	net = IrohaGrpc()

Burada hesap bilgisi örneğini görebilirsiniz.
Komutlarla birlikte daha sonra kullanılacaktır.
Eğer işlemdeki komutu değiştirirseniz,
bu bölümdeki veri kümesi ayrıca neye ihtiyacınız olduğuna bağlı olarak değişebilir.

Komutları tanımlama
-------------------

Tanımlanmış komutların ilkine bakalım:

.. code-block:: python

	def create_domain_and_asset():
	    commands = [
	        iroha.command('CreateDomain', domain_id='domain', default_role='user'),
	        iroha.command('CreateAsset', asset_name='coin',
	                      domain_id='domain', precision=2)
	    ]
	    tx = IrohaCrypto.sign_transaction(
	        iroha.transaction(commands), admin_private_key)
	    send_transaction_and_print_status(tx)

Burada 2 komuttan oluşan bir işlem tanımlarız: CreateDomain ve CreateAsset.
Tam listeyi buradan bulabilirsiniz: `Komutlar <../develop/api/commands.html>`_.
Her Iroha komutu kendi parametre kümesine sahiptir.
`iroha-api-reference <../develop/api.html>`_'deki komut açıklamalarında kontrol edebilirsiniz.

Sonrasında, daha önce tanımlanmış parametrelerle işlemi imzalarız.

`Sorguları <../develop/api/queries.html>`_ aynı yolla tanımlayabilirsiniz.

Komutları çalıştırma
--------------------

Son satırlar

.. code-block:: python

	create_domain_and_asset()
	add_coin_to_admin()
	create_account_userone()
	...

daha önce tanımlanmış komutları çalıştırın.

Şimdi, eğer `irohad` çalıştırıyorsanız, başka bir sekmede .py dosyasını
açarak örneği veya kendi dosyanızı çalıştırabilirsiniz.
