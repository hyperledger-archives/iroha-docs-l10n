.. _deploy-guide:

========
Dağıtmak
========

Hyperledger Iroha perspektife ve amaca bağlı olarak farklı yollarla dağıtılabilir.
Dağıtılmış tek bir düğüm veya yerel bir makine üzerinde birkaç konteynerda çalışan veya ağa yayılmış birçok düğüm olabilir. — yani ihtiyacınız olan herhangi bir durumu seçin.
Bu sayfa farklı senaryoları tanımlar ve öncelikli olarak Iroha'yı ilk kez deneyen kullanıcılar için nasıl kullanılacağına dair bir kılavuz olarak harekete geçmeyi hedeflemiştir.

Security notice
===============

Due to a known issue with `gRPC <https://github.com/grpc/grpc/issues/20418>`_ it might not be safe to deploy Iroha in production natively on MacOS or on older versions of Linux.

The issue might cause Iroha to crash due to socket exhaustion and unless it is set up correctly, using, say, Docker, it will need to be restarted manually which might disrupt the work.
You can learn more about why the issue affects MacOS and noncontemporary Linux systems in `this article <https://grpc.github.io/grpc/core/md_doc_core_grpc-polling-engines.html>`_ (the way gRPC uses polling engine in Mac is susceptible to this type of vulnerability and unlike Linux it cannot be avoided by using other options of polling engines).

So, to be on the safe side, please try to deploy on newer versions of Linux (see the version numbers in the article above) and use Docker with Linux if you prefer MacOS in the production environment.

.. toctree::
      :maxdepth: 1

      single.rst
      multiple.rst
      k8s-deployment.rst
      troubles.rst
