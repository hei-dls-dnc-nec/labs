#import "/res/helpers.typ" : *

#let nf(glyph, size: 2.8em) = text(font: "JetBrainsMonoNL NFM", size: size, glyph)
#let dashed = (paint: hei-gray, thickness: 1pt, dash: "dashed")
#let server-web = text(size: 0.8em)[Dashboard]
#let client-web = text(size: 0.8em)[Browser]
#let server-app = text(size: 0.8em)[Modbus Server \ TCP/1502]
#let client-app = text(size: 0.8em)[Dashboard]

#let modbus-setup-fig = context {
  let capture = text(size: 0.7em)[#nf("\u{f1673}", size: 1.4em) Wireshark capture]
  // All application boxes get the width of the widest element plus some room, so server and client have the same size
  let app-width = calc.max(..(server-web, client-web, server-app, client-app, capture).map(it => measure(it).width)) + (2em).to-absolute()
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
    // Stations: a frame enclosing the title and the applications, the application linked to the ETH is on row 2
    // Server: title (row -1), dashboard (row 1), Modbus server (row 2), both frames span the same rows
    // Client: title (row -1), browser (row 0), dashboard (row 1), Modbus client (row 2), Wireshark capture point (row 3)
    node((0, -1), inset: 0pt)[#nf([]) *Server*],
    node((6, -1), inset: 0pt)[*Client*],
    // The frame only fits around the nodes at the listed coordinates, row 2 holds the widest box
    node(enclose: ((0, -1), (0, 2), (0, 3)), inset: margin, layer: -2, snap: false, stroke: 1pt + hei-gray),
    node(enclose: ((6, -1), (6, 2), (6, 3)), inset: margin, layer: -2, snap: false, stroke: 1pt + hei-gray),
    node((3, 2), stroke: 1pt + hei-gray)[
      *Edge Router* \
      #text(size: 0.8em)[(switch ports)]
    ],
    // Empty columns to leave room for the cables
    node((2, 2), box(width: 3.5em)),
    node((4, 2), box(width: 3.5em)),
    app-box((0, 1), server-web),
    // Dashboard uses the Modbus server
    edge((0, 1), (0, 2), "-", stroke: 1pt + hei-gray),
    app-box((6, 0), client-web),
    // Browser uses the dashboard
    edge((6, 0), (6, 1), "-", stroke: 1pt + hei-gray),
    app-box((6, 1), client-app),
    // Dashboard uses the Modbus client
    edge((6, 1), (6, 2), "-", stroke: 1pt + hei-gray),
    // Ethernet interface on the edge of each station
    // Edges start at the ETH centre (no snapping) and run under the ETH box
    // The ETH column is twice the margin wide, so the ETH box is centred on the station frame
    ..for (iface, station, app) in ((1, 0, server-app), (5, 6, text(size: 0.8em)[Modbus Client])) {(
      app-box((station, 2), app),
      node((iface, 2), inset: 0pt, box(width: 2 * margin, align(center, box(width: 2em, fill: hei-gray, inset: 4pt, radius: 3pt)[
        #text(size: 0.7em, fill: white)[*ETH*]
      ]))),
      edge((iface, 2), (3, 2), "-", stroke: 1pt + hei-gray, layer: -1, snap-to: (none, auto)),
      edge((iface, 2), (station, 2), "-", stroke: 1pt + hei-gray, layer: -1, snap-to: (none, auto)),
    )},
    // Client ETH selected as Wireshark capture point
    node((6, 3), stroke: dashed, inset: 4pt, corner-radius: 4pt, capture),
    // Invisible copy on the server, so both frames get the same size
    node((0, 3), inset: 4pt, hide(capture)),
    // Starts under the ETH box and drops inside the station frame
    edge((5, 2), (6 - drop, 2), (6 - drop, 3), (6, 3), "-|>", stroke: dashed, layer: -1, snap-to: (none, auto)),
  )
}
