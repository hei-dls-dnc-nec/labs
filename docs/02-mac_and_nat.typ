#import "/res/helpers.typ" : *

#show: template.with(
  authors: authors,
  task_number: 2,
  serie_title: "MAC and NAT",
  pictures: none, //image("res/Task2.png", width: 75%),
  abstract: [
    #lorem(20)
  ]
)

// Week 9: 2h

#todo[
  [R]
  + MAC / ARP
    + Task
      - List ARP table / clear ARP table
      - Ping RPI
      - List ARP table and explain its content.
      - What is the MAC address of the RPI?

    + Task
      - clear ARP table
      - Wireskark: Filter on ARP and ICMP
      - Ping RPI
      - Questions:
        - What is the MAC and IP address of the RPI?
        - What is your MAC and IP address?
        - WHat is the MAC address `FF:FF:FF:FF:FF:FF`?
        - Explain the captured ARP/ICMP sequences
    + Task
      - clear ARP table
      - Wireskark: New capture, Filter on ARP and ICMP
      - Ping RPI
      - Ping RPI again
      - Explain the different sequences of the first and second ping execution

  + NAT: IP Masquerade
    + Task
      - Setup:
        - Laptop 1 on EdgeRouter
        - Laptop 2 on the blue net
        - Laptop 2 is running the dashboard from homelab
        - Both laptops are running wireskark, filtering on the port of the dashboard
      - Find the IP of laptop 2
      - From laptop 1 access the dashboard on laptop 2
      - Explain and compare the captures an laptop 1 and laptop 2
        - Src & Dst IPs, where do they come from?
        - Src & Dst ports, where do they come from?

  + NAT: Access to public networks
    + Task
      - Setup static lease for laptop 2
      - Access the dashboard on the laptop 2 from laptop 1
      - Setup captures
    + Task
      - Setup incoming on the EdgeRouter for accessing the dashboard on the laptop 2
      - Explain the configuration
    + Task
     - Access the dashboard on the laptop 1 from laptop 2 (WAN side) and capture the traffic.
     - Explain and compare the captures
        - Src & Dst IPs, where do they come from?
        - Src & Dst ports, where do they come from?

    + Options: Add traceroute task
]
