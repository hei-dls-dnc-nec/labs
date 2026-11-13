#import "/res/helpers.typ" : *
#import "@preview/chronos:0.3.0"

#import "/res/img/02-mac_and_nat/arp-setup-fig.typ": *
#import "/res/img/02-mac_and_nat/nat-masquerade-fig.typ": *
#import "/res/img/02-mac_and_nat/nat-port-forwarding-fig.typ": *

#show: template.with(
  authors: authors,
  task_number: 2,
  serie_title: "ARP, MAC and NAT",
  pictures: none, //image("res/Task2.png", width: 75%),
  abstract: [
    This laboratory explores Layer 2 addressing and Network Address Translation (NAT) on the IIoT Rack. You will first inspect the MAC addresses and the ARP resolution used to reach the Raspberry Pi (#raspberry-pi-ip / #raspberry-pi-dns-name) and analyse the ARP and ICMP traffic with Wireshark. Working in pairs, you will then connect two laptops to the EdgeRouter's LAN and WAN (blue network) interfaces to observe outbound NAT (IP Masquerade) with Wireshark, and finally configure inbound NAT (Port Forwarding) on the EdgeRouter to expose the SCADA dashboard to the WAN.
  ]
)

#let list-arp-table = (
  windows: "arp -a",
  macos: "arp -a",
  linux: "ip neigh",
)

#let clear-arp-cache = (
  windows: "arp -d *",
  macos: "sudo arp -d -a",
  linux: "sudo ip neigh flush all",
)

#let single-ping = (
  windows: "ping -n 1 #raspberry-pi-ip",
  macos: "ping -c 1 #raspberry-pi-ip",
  linux: "ping -c 1 #raspberry-pi-ip",
)


// Week 9: 2h

= MAC and ARP
Connect your laptop to the EdgeRouter LAN with an Ethernet cable, as you did in the previous lab. The Raspberry Pi (#raspberry-pi-ip / #raspberry-pi-dns-name), located at the bottom of the IIoT Rack (@fig:iiot-rack:hardware), is connected to the same LAN.

#figure(
  image("../res/img/iiot-rack-hardware.svg", width: 60%),
  caption: [IIoT Rack - hardware]
) <fig:iiot-rack:hardware>

In this section, you will investigate how your computer discovers the Layer 2 MAC address corresponding to an IPv4 address, using the Address Resolution Protocol (ARP). You will capture this traffic with Wireshark but this time you will have to search how to do the filter you need.

#task[Inspect the ARP table][
  You will inspect and clear your operating system's ARP cache, generate traffic toward the Raspberry Pi (#raspberry-pi-ip), and examine the resulting ARP table entry. Show and explain the ARP table in your report.

  Some of the command line tools used in this task require Administrator privileges. On Windows, we recommend you to open a Command Prompt as Administrator (right-click on the Start menu, select "Command Prompt (Admin)" or "Windows PowerShell (Admin)"). On macOS and Linux, you can use `sudo` to run commands with elevated privileges, no need to open a root shell.

  #subtask[
    Open a terminal and list the current ARP table.

    #grid(
      columns: (1fr, 5fr),
      align: left+horizon,
      inset: 0.5em,
      [*Windows*],
      shell(raw(list-arp-table.windows, block: true, lang: "shell")),

      [*MacOS*],
      shell(raw(list-arp-table.macos, block: true, lang: "shell")),

      [*Linux*],
      shell(raw(list-arp-table.linux, block: true, lang: "shell")),
      [], [
        On Linux, you can also use the legacy `arp -a` command.
      ]
    )
  ]


  #subtask[
    Clear your ARP table so that no cached MAC addresses remain.

    #grid(
      columns: (1fr, 5fr),
      align: left+horizon,
      inset: 0.5em,
      [*Windows (admin)*],
      shell(raw(clear-arp-cache.windows, block: true, lang: "shell")),

      [*MacOS*],
      shell(raw(clear-arp-cache.macos, block: true, lang: "shell")),

      [*Linux*],
      shell(raw(clear-arp-cache.linux, block: true, lang: "shell")),
    )

    Verify with that current ARP table is almost empty. Do you still have entry? If yes, why and what is this entry for?
  ]

  #subtask[
    Ping once the Raspberry Pi at #raspberry-pi-ip:

    #grid(
      columns: (1fr, 5fr),
      align: left+horizon,
      inset: 0.5em,
      [*Windows*],
      shell(raw(single-ping.windows, block: true, lang: "shell")),

      [*MacOS*],
      shell(raw(single-ping.macos, block: true, lang: "shell")),

      [*Linux*],
      shell(raw(single-ping.linux, block: true, lang: "shell")),
    )
  ]

  #subtask[
    List the ARP table again right after the ping.
    In your report, show the output, explain each column / field of the ARP table, and give the MAC address of the Raspberry Pi.
  ]
]

#pagebreak()

#task[Analyse ARP and ICMP in Wireshark][
  You will now capture the exact packet sequence on the wire when your laptop pings the Raspberry Pi, starting from an empty ARP table. Illustrate your answers with Wireshark screenshots and explain them in your report.

  #figure([
    #arp-setup-fig
    ],
    caption: [LAN setup - laptop pinging the Raspberry Pi through the EdgeRouter]
  ) <fig:arp:setup>

  #subtask[
    Clear your ARP table again: #raw(clear-arp-cache.windows) on Windows (admin), #raw(clear-arp-cache.macos) on macOS, or #raw(clear-arp-cache.linux) on Linux.
  ]

  #subtask[
    Open Wireshark, select your Ethernet LAN interface, start a new capture and apply an adapted filter. Document in your report the filter you used.
  ]

  #subtask[
    Send a single ICMP echo request to the Raspberry Pi
    (complex words to say a single ping #emoji.face.wink) // We can remove this, I was just tired xD
    .
  ]

  #subtask[
    Stop the Wireshark capture and answer the following questions in your report (illustrate with Wireshark screenshots):

    - What are the MAC and IP addresses of the Raspberry Pi?
    - What are your laptop's MAC and IP addresses?
    - What is the special MAC address `FF:FF:FF:FF:FF:FF`, and why is it used?

  ]

  #subtask[
    Explain step by step the captured ARP and ICMP packet sequence (ARP Request, ARP Reply, ICMP Echo Request, ICMP Echo Reply).
    Draw a sequence diagram the shows the sequence of packets captured starting withe the execution of the ping command.
    Complete the following draft:

    #figure(
      chronos.diagram({
        import chronos: *
        _par("user", display-name: "User", shape: "actor")
        _par("l", display-name: "Laptop")
        _par("rpi", display-name: "Raspberry Pi")
        _par("edge", display-name: "Edge Router")

        _seq("user", "l", comment: [`ping -c 1 192.168.1.4`], enable-dst: true)
        _seq("l", "rpi", comment: [?], dashed: true)
        _delay(name: [])
        _seq("rpi", "l", comment: [?], dashed: true)
        _seq("l", "user", comment: [ping result], disable-src: true)
      }),
      caption: [Draft of the sequence diagram of a single ping]
    ) <fig:arp:sequence-draft>
  ]
]


#task[ARP caching behaviour][
  You will now compare two consecutive single-packet `ping` executions to observe the effect of the local ARP cache. Show both packet sequences in your report and explain the difference.

  #subtask[
    Clear your ARP table again, and start a new Wireshark capture with the adapted filter.
  ]

  #subtask[
    Execute a first single ping to the Raspberry Pi as before.
  ]

  #subtask[
    Immediately execute a second single ping *without* clearing the ARP table in between.
  ]

  #subtask[
    Stop the capture. In your report, compare and explain the difference between the packet sequence of the first ping execution and the second ping execution. Why was no ARP traffic generated during the second ping?
  ]
]

#task[Ping an external host][
  You will now ping a host outside of your LAN: the public DNS server of Google, `8.8.8.8`.

  #subtask[
    Clear the ARP table and start a new Wireshark capture as in the previous tasks.
  ]

  #subtask[
    Ping `8.8.8.8` once, stop the capture and show the ARP table.
  ]

  #subtask[
    Answer in your report and illustrate with your capture:
    - For which IP address does the laptop send an ARP request? Why not for `8.8.8.8`?
    - What are the destination MAC and the destination IP address of the echo request?
  ]
][][]

#pagebreak()

= NAT — IP Masquerade
Up to now, all communication happened inside the same local network with private addresses within `192.168.1.0/24`. You will now work in pairs across two different networks separated by the EdgeRouter:

- *Laptop 1* stays connected to the *EdgeRouter LAN* (`192.168.1.0/24`).
- *Laptop 2* connects to the *blue network* (the upstream / WAN network to which the EdgeRouter's WAN interface is connected).

You will observe how the EdgeRouter translates addresses using *IP Masquerade* (Source NAT / SNAT) when a host on the private LAN initiates a connection to a host on the WAN, usably with pubic IP address.

#infobox[
  The blue net is itself an internal network of the school: it also uses private IP addresses, from another range than the LAN of your rack.
  From the point of view of your rack, it plays the role of the "outside" network (WAN).
  On its way to the Internet, a packet crosses a further NAT router of the school network.
]


#task[Outbound traffic through NAT][
  Laptop 2 (on the blue network / WAN) will act as the server running the SCADA dashboard from the previous lab (`main.py` on port #traffic-port-http). Laptop 1 (on the EdgeRouter LAN) will connect to it. Both laptops will capture the traffic in Wireshark and compare what each side sees.

  #figure([
    #nat-masquerade-fig
    ],
    caption: [Laptop 1 (LAN client) accessing Laptop 2 (WAN server) through the EdgeRouter]
  ) <fig:nat:masquerade>

  #subtask[
    Physical and software setup:

    - Connect *Laptop 1* to a LAN port of the EdgeRouter (`192.168.1.0/24`).
    - Connect *Laptop 2* to the *blue network* (WAN side of the EdgeRouter).
    - Ensure Wi-Fi is turned off on both laptops.
    - On *Laptop 2*, start the SCADA dashboard (`main.py` from the `dashboard` folder in PyCharm) so it listens on port #traffic-port-http.
  ]

  #subtask[
    Find the IPv4 address of *Laptop 2* on the blue network (`ipconfig` on Windows, `ip a` or `ifconfig` on Linux / macOS) and note the WAN IPv4 address of the EdgeRouter. You can find it in the EdgeRouter web interface under the Dashboard tab (user #iiot-rack-router-user, password #iiot-rack-router-pwd).
  ]

  #subtask[
    On *both Laptop 1 and Laptop 2*, open Wireshark on the active Ethernet interface, start a capture and filter on the dashboard port.
  ]

  #subtask[
    From *Laptop 1* (EdgeRouter LAN), open a browser and navigate to `http://<IP_of_Laptop_2>:8050`.
    In the "HTTP Traffic Generator" tab, click "Start HTTP Polling" for a few seconds, then stop the polling and stop both Wireshark captures.
  ]

  #subtask[
    Compare the Wireshark captures recorded on *Laptop 1* and *Laptop 2*. In your report, provide screenshots from both laptops and answer the following questions:

    - What are the *Source IP* and *Destination IP* seen by Laptop 1 vs. seen by Laptop 2 (for both requests and responses)? Where do these IP addresses come from, and why do they differ?
    - What are the *Source TCP port* and *Destination TCP port* seen on Laptop 1 vs. Laptop 2? Where do they come from?
  ]
]

#pagebreak()

= NAT — Port Forwarding (Access from Public / WAN Network)
By default, IP Masquerade only allows connections initiated from the internal LAN toward the outside network. External hosts on the WAN (the blue network) cannot directly initiate connections to the private LAN IP addresses (`192.168.1.x`).
To expose an internal service running on *Laptop 1* inside the LAN to clients on the WAN (*Laptop 2* on the blue network), you must configure a static DHCP lease and *Port Forwarding* (Destination NAT / DNAT) on the EdgeRouter.

#warningbox[
  Keep the physical cabling identical to the previous section:
  - *Laptop 1* stays on the *EdgeRouter LAN*
  - *Laptop 2* stays on the *blue network / WAN*.
]

#figure([
  #nat-port-forwarding-fig
  ],
  caption: [Laptop 2 (WAN client) accessing Laptop 1 (LAN server) through the EdgeRouter]
) <fig:nat:port-forwarding>

#task[Prepare LAN server and observe WAN isolation][
  You will first assign a fixed IP address to *Laptop 1* on the EdgeRouter LAN and run the SCADA dashboard on *Laptop 1*. Before configuring Port Forwarding, you will verify whether *Laptop 2* (on the WAN) can reach *Laptop 1*.

  #subtask[
    Stop the dashboard on *Laptop 2* and start the SCADA dashboard (`main.py`, port #traffic-port-http) on *Laptop 1* (connected to the EdgeRouter LAN).
  ]

  #subtask[
    Log in to the EdgeRouter web interface and configure a *Static DHCP Mapping* for *Laptop 1* like you did in the previous lab for the Raspberry Pi. This time, set the IP #laptop-ip for *Laptop 1*'s MAC address.

    Unplug and replug Laptop 1's Ethernet cable so it renews its DHCP lease, and verify that Laptop 1 has received its fixed LAN IP address.
  ]

  #subtask[
    On *Laptop 1* (LAN) and *Laptop 2* (blue network / WAN), start a Wireshark capture with the adapted filter.
  ]

  #subtask[
    From *Laptop 2* (blue network), try to access the dashboard on *Laptop 1* in your browser, both via `http://192.168.1.100:8050` and via `http://<EdgeRouter_WAN_IP>:8050`.
  ]
  // TODO fix the hardcoded ip

  #subtask[
    Observe what happens in the browser and in both Wireshark captures. Explain in your report why *Laptop 2* cannot reach *Laptop 1*'s private LAN IP address directly, and why connecting to the EdgeRouter's WAN IP fails before Port Forwarding is configured.
  ]
]

#task[Configure Port Forwarding on the EdgeRouter][
  You will now configure an inbound Port Forwarding rule on the EdgeRouter so that incoming TCP traffic arriving on the EdgeRouter's WAN interface is forwarded to *Laptop 1* on the LAN.

  #subtask[
    Open the EdgeRouter web interface (`192.168.1.1`) and navigate to the Port Forwarding configuration menu.
    #infobox[
      The menu in the Ubiquiti router can be found under:\
      `Firewall/NAT` $->$ `Port Forwarding`
    ]
  ]

  #subtask[
    Configure a port forwarding rule with the following parameters:

    - *Original Port (External WAN Port):* `80`
    - *Protocol:* `TCP` (or `TCP and UDP`)
    - *Forward-to Address:* #laptop-ip
    - *Forward-to Port (Internal LAN Port):* `8050`
  ]

  #subtask[
    In your report, include a screenshot of your EdgeRouter Port Forwarding configuration and explain the role of each field: `WAN interface`, `LAN interface`, `Original port`, `Forward-to address`, `Forward-to port` and `Auto firewall`.
  ]
]

#task[Analyse Port Forwarding (DNAT) traffic][
  With Port Forwarding active, you will now access *Laptop 1*'s dashboard (on the LAN) from *Laptop 2* (on the WAN / blue network) and compare the Wireshark captures on both ends.

  #subtask[
    Start a new Wireshark capture on *Laptop 1* (LAN) and *Laptop 2* (WAN). Which filter should you use to capture the relevant traffic?
  ]

  #subtask[
    From *Laptop 2* (blue network / WAN), open a browser and navigate to `http://<EdgeRouter_WAN_IP>:80`. Start HTTP polling in the dashboard for a few seconds, then stop the polling and stop both captures.
  ]

  #subtask[
    Compare the packets captured on *Laptop 2* (WAN client) and *Laptop 1* (LAN server). In your report, include screenshots from both laptops and answer the following questions:

    - What are the *Source IP* and *Destination IP* seen by *Laptop 2* vs. seen by *Laptop 1* (for both the incoming HTTP requests and the outgoing HTTP responses)? Where do they come from?
    - What are the *Source TCP port* and *Destination TCP port* seen by *Laptop 2* vs. seen by *Laptop 1*? Where do they come from?
    - Contrast this inbound Port Forwarding (DNAT) behaviour with the outbound IP Masquerade (SNAT) behaviour you observed in Task 4.
  ]
]

#bonus[Traceroute across NAT][
  Use the `traceroute` / `tracert` diagnostic tool to discover the intermediate router hops along the path between the LAN and the blue network, and observe how NAT affects path discovery in both directions.

  #subtask[
    Start a Wireshark capture on *Laptop 1* and *Laptop 2* with the display filter `udp`.
  ]

  #subtask[
    From *Laptop 1* (EdgeRouter LAN), run a traceroute toward *Laptop 2*'s IP address on the blue network.

    #grid(
      columns: (2fr, 5fr),
      align: left+horizon,
      inset: 0.5em,
      [*Windows*],
      shell[```
        tracert -d <IP_of_Laptop_2>
      ```],

      [*MacOS / Linux*],
      shell[```
        traceroute -n <IP_of_Laptop_2>
      ```]
    )
  ]

  #subtask[
    Next, from *Laptop 2* (blue network / WAN), run a traceroute toward *Laptop 1*'s private LAN IP address (#laptop-ip).
  ]

  #subtask[
    In your report, show the command outputs and Wireshark captures, explain how `traceroute` uses the IPv4 *TTL (Time To Live)* field and *ICMP Time Exceeded* messages to discover each hop, and explain why the results differ between the LAN-to-WAN direction and the WAN-to-LAN direction.
  ]
]
