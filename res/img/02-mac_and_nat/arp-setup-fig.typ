#import "/res/helpers.typ" : *

#let nf(glyph, size: 2.8em) = text(font: "JetBrainsMonoNL NFM", size: size, glyph)
#let dashed = (paint: hei-gray, thickness: 1pt, dash: "dashed")
#let rpi-app = text(size: 0.8em)[ICMP / ARP]
#let client-app = text(size: 0.8em)[Terminal (ping) \ ICMP / ARP]

#let arp-setup-fig = context {
  let capture = text(size: 0.7em)[#nf("\u{f1673}", size: 1.4em) Wireshark capture]
  // All application boxes get the width of the widest element, so both stations have the same size
  let app-width = calc.max(..(rpi-app, client-app, capture).map(it => measure(it).width)) + (1em).to-absolute()
  let app-inset = 5pt
  // Space between the application and the station frame, the ETH box is centred on the frame
  let margin = 18pt
  // Fraction between station and ETH column where the capture arrow drops, half way through the margin
  let half = app-width / 2 + app-inset
  let drop = (half + margin / 2) / (half + margin)
  let app-box(pos, body) = node(pos, stroke: dashed, inset: app-inset, corner-radius: 4pt, box(width: app-width, align(center, body)))
  diagram(
    spacing: (0pt, 8pt),
    node-inset: 6pt,
    node-corner-radius: 6pt,
    node-shape: rect,
    // Stations: a frame enclosing title (row 0), application (row 1) and Wireshark capture point (row 2)
    node((0, 0), inset: 0pt)[*Raspberry Pi* \ #text(size: 0.75em, fill: hei-gray)[192.168.1.4]],
    node((6, 0), inset: 0pt)[*Laptop* \ #text(size: 0.75em, fill: hei-gray)[192.168.1.x]],
    node(enclose: ((0, 0), (0, 2)), inset: margin, layer: -2, snap: false, stroke: 1pt + hei-gray),
    node(enclose: ((6, 0), (6, 2)), inset: margin, layer: -2, snap: false, stroke: 1pt + hei-gray),
    node((3, 1), stroke: 1pt + hei-gray)[
      *Edge Router* \
      #text(size: 0.8em)[(switch ports)] \
      #text(size: 0.75em, fill: hei-gray)[192.168.1.0/24]
    ],
    // Empty columns to leave room for the cables
    node((2, 1), box(width: 3.5em)),
    node((4, 1), box(width: 3.5em)),
    // Ethernet interface on the edge of each station
    ..for (iface, station, app) in ((1, 0, rpi-app), (5, 6, client-app)) {(
      app-box((station, 1), app),
      node((iface, 1), inset: 0pt, box(width: 2 * margin, align(center, box(width: 2em, fill: hei-gray, inset: 4pt, radius: 3pt)[
        #text(size: 0.7em, fill: white)[*ETH*]
      ]))),
      edge((iface, 1), (3, 1), "-", stroke: 1pt + hei-gray, layer: -1, snap-to: (none, auto)),
      edge((iface, 1), (station, 1), "-", stroke: 1pt + hei-gray, layer: -1, snap-to: (none, auto)),
    )},
    // Laptop ETH selected as Wireshark capture point
    node((6, 2), stroke: dashed, inset: 4pt, corner-radius: 4pt, capture),
    // Invisible copy on the Raspberry Pi, so both frames get the same size
    node((0, 2), inset: 4pt, hide(capture)),
    // Starts under the ETH box and drops inside the station frame
    edge((5, 1), (6 - drop, 1), (6 - drop, 2), (6, 2), "-|>", stroke: dashed, layer: -1, snap-to: (none, auto)),
  )
}
