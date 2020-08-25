.. _deploy_troubles:

======================
Sorunlar ile ilgilenme
======================

—"Lütfen, yardım edin, çünkü ben…"

Iroha arkaplan program ikilisine sahip olmamak
----------------------------------------------

Kaynaklardan Iroha arkaplan programı ikilisini oluşturabilirsiniz. `Buradan <https://github.com/hyperledger/iroha/releases>`__ ikilileri edinebilirsiniz.

Yapılandırma dosyasına sahip olmamak
------------------------------------

Bu `linki <../configure/index.html>`__ takip ederek yapılandırma dosyasının nasıl oluşturulacağını kontrol edebilirsiniz.

Genesis bloğa sahip olmamak
---------------------------

`Örneği <https://github.com/hyperledger/iroha/blob/master/example/genesis.block>`__ kullanarak ve `izinleri <../develop/api/permissions.html>`__ kontrol ederek `iroha-cli` aracılığıyla veya manuel bir şekilde genesis bloklarını oluşturabilirsiniz.

Bir eş için anahtar çiftine sahip olmamak
-----------------------------------------

Bir hesap veya eş için bir anahtar çifti oluşturmak için, `--new_account` seçeneğiyle eşin adını ileterek iroha-cli ikili dosyasını kullanın.
Örnek olarak:

.. code-block:: shell

    ./iroha-cli --account_name newuser@test --new_account
