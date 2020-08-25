Varlık-ilişki modeli
====================

Her Hyperledger Iroha eşi varlıklar kümesi ve bu kümeler arasındaki ilişki ile temsil edilen "World State View" adı verilen bir duruma sahiptir.
hangi varlıkların sistemde varolduğunu ve ilişkilerinin ne olduğu açıklamak için, bu bölüm ER diyagram ve bileşenlerinin açıklamasını içerir.

ER diyagram
----------

.. image:: ./../../image_assets/er-model.png

Eş
----

 - address — ağ adresi ve dahili bağlantı noktası, senkronizasyon için kullanılır, konsensüs, ordering service ve ile iletişim 
 - public_key — anahtar, konsensüs süreci boyunca blokları imzalamak için kullanılacak

Varlık
------

 - asset_id — varlık tanımlayıcı, asset_name#domain_id olarak biçimlendirilmiş
 - domain_id — alan adı tanımlayıcı, varlık nerede tanımlandı, var olan alan adını referans gösterir
 - precision — kesirli parçanın boyutu

İmza sahibi
-----------

 - public_key — genel anahtar

Alan adı
--------

 - domain_id — alan adı tanımlayıcı
 - default_role — alanda yaratılan her kullanıcının varsayılan rolü, var olan rolleri referans gösterir

Rol
---

 - role_id — rol tanımlayıcı

RoleHasPermissions
^^^^^^^^^^^^^^^^^^

 - role_id — rol tanımlayıcı, var olan rolleri referans gösterir
 - permission_id — izin tanımlayıcı

Hesap
-----

 - account_id — hesap tanımlayıcı, account_name@domain_id olarak biçimlendirilmiş
 - domain_id — hesabın yaratıldığı alanın tanımlayıcısı, var olan alanı referans gösterir 
 - quorum — bu hesaptan geçerli işlem yaratmak için gereken imzaların sayısı
 - transaction_count – hesap tarafından yaratılan işlemlerin sayacı
 - data — hesap ile ilişkili herhangi bir bilgi için anahtar-değer depolama alanı. Boyut 268435455 bytes (0x0FFFFFFF) ile sınırlandırılmıştır (PostgreSQL JSONB alanı).

AccountHasSignatory
^^^^^^^^^^^^^^^^^^^

 - account_id — hesap tanımlayıcı, var olan hesapları referans gösterir 
 - public_key — genel anahtar (ayrıca imza sahibi olarak isimlendirilir), var olan imza sahiplerini referans gösterir 

AccountHasAsset
^^^^^^^^^^^^^^^

 - account_id — hesap tanımlayıcı, var olan hesapları referans gösterir
 - asset_id — varlık tanımlayıcı, var olan varlıkları referans gösterir
 - amount — varlıkların miktarı, hesaba ait olanlar

AccountHasRoles
^^^^^^^^^^^^^^^

 - account_id — hesap tanımlayıcı, var olan hesapları referans gösterir
 - role_id — rol tanımlayıcı,  var olan rolleri referans gösterir

AccountHasGrantablePermissions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

 - account_id — hesap tanımlayıcı, var olan hesapları referans gösterir. Bu hesap izin belgesine kendi başına işlem gerçekleştirme izni verir.
 - permittee_account_id — hesap tanımlayıcı, var olan hesapları referans gösterir. Bu hesaba account_id üzerinden işlem yapma izni verildi.
 - permission_id — grantable_permission tanımlayıcı
