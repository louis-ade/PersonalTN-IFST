            +------------------------+
            |    Tailscale Tailnet   |
            +------------------------+
                         | (Auth)
                 +--------+--------+
                 | VIRTUAL NETWORK |
      +----------+------+  +-------+-----------+
      | Subnet Router VM |  | Tailscale Device |
      |    AZURE VM      |  |    AZURE VM      |
      +------------------+  +------------------+
                |                   |
               SSH                 SSH
