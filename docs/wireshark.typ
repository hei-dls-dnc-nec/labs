#import "/res/helpers.typ" : *

#show: template.with(
  authors: authors,
  task_number: none,
  serie_title: "Wireshark",
  pictures: image("/res/img/wireshark/icon.svg", width: 50%),
  abstract: [
    Wireshark is a free and open-source packet analyser. It is used for network troubleshooting, analysis, software, and communications protocol development.
    
    During your lab, you will use Wireshark to capture and analyse network traffic. You will also learn how to use filters to focus on specific packets and protocols.
  ]
)

= Installation
To install Wireshark, you can simply go to the official website:

#infobox[https://www.wireshark.org/#download]

During the installation, you need to install Wireshark `core` and `Tsharp`. You can also select `sshdump` at it can be useful in some labs. 
#figure(
  image("../res/img/wireshark/install-ssh.png", width: 75%),
  caption: "Wireshark installation options"
)

You can keep all other options as default. 


#pagebreak()

= Capture
With Wireshark, you can capture packets from different network interfaces.
You need to select the right interface for your objective.
They are several types of interfaces: 
- Wired interfaces (#quan(1) in @fig:wireshark:interfaces) are for physical network cards where you connect an RJ45.
  // This interface usually contain an `eth` or `en` in its name.
- Wireless interfaces (#quan(2) in @fig:wireshark:interfaces) represent your wifi.
  // This interface usually contain a `wlan` or `wl` in its name.
- Internal interfaces (#quan(3) in @fig:wireshark:interfaces) are for your computer's internal network stack.
  This interface usually named `Loopback`, `lo` or `Localhost`.
- Virtual interfaces are for virtual machines, docker, or VPNs.
It's also possible to capture packets from Bluetooth, nfqueue or USB interfaces, but you probably won't use them.

To verify your network card on your OS before select it on Wireshark, use the command below depending on your OS:

#grid(
  columns: (1fr, 6fr),
  align: horizon+left,
  row-gutter: 0.8em,
  [*Windows*:],
  shell[```bash ipconfig /all ```],
  grid.cell(colspan: 2)[
    Wireless or wired network card are directly indicated in the output.
  ],
  
  v(1em), [],
  
  [*macOS*:],
  shell[```bash networksetup -listnetworkserviceorder ```],
  grid.cell(colspan: 2)[
    Wireless or wired network card are directly indicated in the output.
  ],
  
  v(1em),[],
  
  [*Linux*:],
  shell[```bash ip -a ```],
  grid.cell(colspan: 2)[
    Usually, wired network card contain `eth` or `en` in its name and wireless network card `wlan` or `wl`.
  ]
)

#figure(
  image("../res/img/wireshark/interfaces-annoted.png", width: 90%),
  caption: "Wireshark interfaces"
) <fig:wireshark:interfaces>

Once you select the right interface, you can define a capture filter.
There are two types of filters in Wireshark: capture filter and display filter.
Capture filter is used to limit the packets captured by Wireshark.
Display filter is used to limit the packets displayed by Wireshark.
You can use both filters at the same time.
We strongly recommend you to use good capture filter to limit the number of packets captured by Wireshark.
You can use a display filter to focus on specific packets and protocols.

#pagebreak()
== Capture filter
You can typically use capture filter (#quan(4) in @fig:wireshark:interfaces) to get a packet from or to a specific IP address, port, or protocol. 
To filter for a specific IP address, you can use the following syntax:
#shell[```
  src|dst host <IP_ADDRESS>
```]
_Example: `src host 192.168.2.5` filter packets from the source IP 192.168.2.5_

Same idea for filtering on port, you can use the following syntax:
#shell[```
  src|dst port <PORT>
```]
_Example: `src port 80` filter packets from the source port 80_

You can also combine filters with `and` and `or` operators. For example, to filter packets from a specific IP and port, you can use the following syntax:
#shell[```
  src|dst host <IP_ADDRESS> and|or src|dst port <PORT>
```]
_Example: `src host 192.168.2.5 and src port 80` filter packets from the source IP 192.168.2.5 and the source port 80_

You can also use `not` operator to filter packets that do not match a specific filter. For example, to filter packets that are not from a specific IP address, you can use the following syntax:
#shell[```
  not src|dst host <IP_ADDRESS>
```]
_Example: `not src host 192.168.2.5` filter packets that are not from the source IP 192.168.2.5_

You can also specify the protocol you want to filter on: 
#shell[```
  tcp|udp src|dst port <PORT>
```]
_Example: `tcp src port not 22` filter TCP packets that are not from the source port 22_

#infobox[
  You can find more information and example on the official Wireshark wiki: \
  https://wiki.wireshark.org/CaptureFilters
]

#pagebreak()
== Display filter
Display filter is used to limit the packets displayed by Wireshark. Specially useful to focus on specific packets and protocols. You can have more powerful filter with display filter than capture filter as you can filter on packet content. 

You can again filter on IP address, port, and protocol with `ip.dest`, `ip.src`, `tcp.srcport`, `tcp.dstport`.
But you can also filter on specific URL with `http.host` or on time with `frame.time`. 
But a more interesting and powerful feature is the ability to filter on specific protocol fields. For example, you can filter on Modbus function code with `modbus.func_code` to display only Modbus with a specific function code.

A Display filter work with the following syntax: `tag <operator> value`.
Where tag can be one of the previous mentioned fields or any other protocol field. The value can be a number, string or boolean. 

Operator can be: 
- `==` equal to. E.g. `ip.src == 192.168.2.5`
- `!=` not equal to. E.g. `ip.dst != 192.168.2.5`
- `>` greater than. E.g. `tcp.srcport > 1000`
- `<` less than. E.g. `tcp.dstport < 1000`
- `>=` greater than or equal to. E.g. `frame.time >= "2022-02-24 20:24:00"`
- `<=` less than or equal to. E.g. `frame.time <= "2026-02-28"`
- `contains` contains a specific value. E.g. `http.host contains "hevs.ch"`
- `in` in a specific range. E.g. `tcp.srcport in {80, 443, 20..25}`

You can aggregate multiple filters with `and`, `or`, `xor` and `not` operators. Here are some examples:
#shell[```
  (tcp.dstport == 80 or tcp.dstport == 443) and not ip.src == 192.168.2.5

  ip.src >= 192.168.2.2 and ip.src <= 192.168.2.10 and tcp.srcport in {80, 443}
  
  ip.dst == 192.168.2.5 and mbtcp.unit_id == 1 and mbtcp.func_code == 1
```]

For Modbus protocol, you can filter on the header with `mbtcp` and on the body with `modbus`. Here are some useful filter for Modbus protocol:
- `mbtcp.unit_id` 
- `mbtcp.trans_id`
- `modbus.func_code`

#infobox[
  You can find more information on the official Wireshark wiki:\
  https://wiki.wireshark.org/DisplayFilters
]


#pagebreak()
= Configuration for Modbus

Wireshark can interpret plenty of protocols. They are on default port, but we won't always use default port for our lab. Often your computer won't let you use port below 1024 without root privileges. So we will use a custom port for our lab. You need to configure Wireshark to interpret Modbus on the custom port.

Go to `Edit` $->$ `Preferences` $->$ `Protocols` $->$ `Modbus/TCP` and add the custom port you will use for your lab. You can add multiple ports if you want to use different ports for different lab. By default, on our lab we will use port 1502 for Modbus/TCP and port 5802 for Modbus/TLS.
#figure(
  image("../res/img/wireshark/modbus-ports.png", width: 75%),
  caption: "Wireshark Modbus configuration"
)


// #pagebreak()
// = Filters cheat sheet
// #todo[
// ]