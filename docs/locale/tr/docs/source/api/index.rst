Iroha API reference
===================

In API section we will take a look at building blocks of an application interacting with Iroha.
We will overview commands and queries that the system has, and the set of client libraries encompassing transport and application layer logic.

Iroha API follows command-query separation `principle <https://en.wikipedia.org/wiki/Command%E2%80%93query_separation>`_.

Communication between Iroha peer and a client application is maintained via `gRPC <https://grpc.io/about/>`_ framework. 
Client applications should follow described protocol and form transactions accordingly to their `description <../core_concepts/glossary.html#transaction>`_.


.. toctree::
    :maxdepth: 2
    :caption: Table of contents

    commands.rst
    queries.rst

Commands here are parts of `transaction <../core_concepts/glossary.html#transaction>`_ - a state-changing set of actions in the system. When a transaction passes validation and consensus stages, it is written in a `block <../core_concepts/glossary.html#block>`_ and saved in immutable block store (blockchain).

Transactions consist of commands, performing an action over an `entity <../core_concepts/er_model.html>`_ in the system. The entity might be an account, asset, etc.



