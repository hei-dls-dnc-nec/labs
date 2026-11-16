#import "/res/helpers.typ" : *

#let nf(glyph, size: 2.8em) = text(font: "JetBrainsMonoNL NFM", size: size, glyph)
#let dashed = (paint: hei-gray, thickness: 1pt, dash: "dashed")
#let wan-blue = rgb("#0095d8").darken(10%)
#let client-app = text(size: 0.8em)[Browser]
#let server-app = text(size: 0.8em)[Dashboard/Python \ TCP/8050]

#let nat-masquerade-fig = context {
  let capture = text(size: 0.7em)[#nf("\u{f1673}", size: 1.4em) Wireshark capture]
  // Both applications get the width of the widest element, so client and server have the same size
  let app-width = calc.max(..(server-app, client-app, capture).map(it => measure(it).width)) + (0.5em).to-absolute()
  let app-inset = 5pt
  // Space between the application and the station frame, the ETH box is centred on the frame
  let margin = 18pt
  // Fraction between station and ETH column where the capture arrow drops, half way through the margin
  let half = app-width / 2 + app-inset
  let drop = (half + margin / 2) / (half + margin)
  diagram(
    spacing: (0pt, 8pt),
    node-inset: 6pt,
    node-corner-radius: 6pt,
    node-shape: rect,
    // Stations: a frame enclosing title (row 0), application (row 1) and Wireshark capture point (row 2)
    node((0, 0), inset: 0pt)[*Laptop 1* \ #text(size: 0.75em, fill: hei-gray)[Client (LAN)]],
    node((6, 0), inset: 0pt)[*Laptop 2* \ #text(size: 0.75em, fill: wan-blue)[Server (WAN)]],
    node(enclose: ((0, 0), (0, 2)), inset: margin, layer: -2, snap: false, stroke: 1pt + hei-gray),
    node(enclose: ((6, 0), (6, 2)), inset: margin, layer: -2, snap: false, stroke: 1pt + hei-gray),
    node((3, 1), stroke: 1pt + hei-gray)[
      *Edge Router* \
      #text(size: 0.8em)[IP Masquerade] \
      #text(size: 0.75em, fill: hei-gray)[(SNAT)]
    ],
    // Cable columns with LAN and WAN labels above/below the cable line
    node((2, 1), inset: 0pt, box(width: 5.5em)[
      #set text(size: 0.7em, fill: hei-gray)
      #place(bottom + center, dy: -4pt)[*LAN*]
      #place(top + center, dy: 4pt)[192.168.1.0/24]
    ]),
    node((4, 1), inset: 0pt, box(width: 5.5em)[
      #set text(size: 0.7em, fill: wan-blue)
      #place(bottom + center, dy: -4pt)[*WAN*]
      #place(top + center, dy: 4pt)[Blue network]
    ]),
    // Cables between stations and router
    edge((1, 1), (3, 1), "-", stroke: 1pt + hei-gray, layer: -1, snap-to: (none, auto)),
    edge((5, 1), (3, 1), "-", stroke: 1.2pt + wan-blue, layer: -1, snap-to: (none, auto)),
    // Ethernet interface on the edge of each station, selected as Wireshark capture point
    ..for (iface, station, inside, app, iface-color) in (
      (1, 0, drop, client-app, hei-gray),
      (5, 6, 6 - drop, server-app, wan-blue),
    ) {(
      node((station, 1), stroke: dashed, inset: app-inset, corner-radius: 4pt, box(width: app-width, align(center, app))),
      node((iface, 1), inset: 0pt, box(width: 2 * margin, align(center, box(width: 2em, fill: iface-color, inset: 4pt, radius: 3pt)[
        #text(size: 0.7em, fill: white)[*ETH*]
      ]))),
      edge((iface, 1), (station, 1), "-", stroke: 1pt + hei-gray, layer: -1, snap-to: (none, auto)),
      node((station, 2), stroke: dashed, inset: 4pt, corner-radius: 4pt, capture),
      // Starts under the ETH box and drops inside the station frame
      edge((iface, 1), (inside, 1), (inside, 2), (station, 2), "-|>", stroke: dashed, layer: -1, snap-to: (none, auto)),
    )},
  )
}
