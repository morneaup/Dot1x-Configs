Here is an example Configuration file that can be deployed that will allow ISE to monitor devices but not enforce on them.

interface Ethernet1/3
dot1x pae authenticator
dot1x port-control auto
dot1x re-authentication
dot1x max-req 1
dot1x host-mode multi-auth
dot1x max-reauth-req 1
dot1x timeout quiet-period 10
dot1x timeout re-authperiod 7200
dot1x timeout tx-period 7
dot1x timeout server-timeout 10
dot1x timeout ratelimit-period 60
dot1x timeout supp-timeout 10
dot1x timeout inactivity-period 7200
dot1x mac-auth-bypass
dot1x authentication order mab
switchport access vlan 20
spanning-tree port type edge

DC-LEAF3(config-if)#
DC-LEAF3(config-if)# end
DC-LEAF3# show dot1x interface ethernet 1/3 summary
Interface PAE Client Status

---

         Ethernet1/3    AUTH   52:54:00:44:F1:2B      AUTHORIZED
