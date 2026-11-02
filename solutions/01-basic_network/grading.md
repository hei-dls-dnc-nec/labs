# Grading Basic Network Lab Exercise

<!-- Generated from grading/grading.yaml; refreshed by `grade check`, `grade render` and `grade spec-md`. Do not edit. -->

Max: **22 points** (tasks 19 + report quality 3), bonus 2.

## General Rules

- Graded on the PDF lab report uploaded to Moodle only.
- Each student uploads their own report, also for the tasks done in pairs.
- Screenshots and text excerpts of Wireshark are equally valid.
- Explanations that lack supporting evidence (e.g., screenshots) will result in a deduction of points.
- A mistake is deducted only once, in the task it belongs to.
- A follow-up mistake is not deducted again.

## Documents

- `report`: Lab report (PDF)

## Run and analyse dashboard locally

- Max Points: 6
- Graded on: Lab report (no tag)
- Rubric:
  - (1) The capture interface is the loopback interface _(judgment)_
    - Expected: `lo0` (macOS), `Adapter for loopback traffic capture` (Windows, Npcap) or `lo` (Linux).
  - (1) A capture filter or a display filter limits the traffic to the dashboard _(judgment)_
    - Expected: Either one is enough: a capture filter on port 8050 in BPF syntax (`tcp port 8050`, `port 8050`) or a display filter (`http`, `tcp.port == 8050`, or narrower on `/api/lab/traffic`). A filter that is only mentioned, without its expression, does not count.
  - (2) A polling request is shown and explained layer by layer _(judgment)_
    - Expected: Null/Loopback (no MAC), IPv4 `127.0.0.1` on both sides, TCP from an ephemeral port to 8050, `GET /api/lab/traffic?size=small&keep_alive=true` with its headers. The page load or the WebSocket `/ws/events` instead of the polling: at most 1 point.
  - (2) The matching response is shown down to the JSON payload _(judgment)_
    - Expected: `HTTP/1.1 200 OK`, `content-type: application/json`, JSON fields `type`, `timestamp`, `cpu_load_pct`, `memory_load_pct` and `requested_size`.

## LAN connection

- Max Points: 4
- Graded on: Lab report (no tag)
- Rubric:
  - (1) The own IP address on the LAN and the method used to find it _(judgment)_
    - Expected: `ipconfig` (Windows), `ifconfig` or `ipconfig getifaddr` (macOS), `ip a` (Linux), the network settings or the DHCP ACK in Wireshark. The address is in `192.168.1.0/24` (pool `.5` to `.15`), not a Wi-Fi or `169.254.x.x` address.
  - (2) Captures on the Ethernet interface of both laptops show the HTTP traffic between them _(judgment)_
    - Expected: Ethernet interface, not loopback. The same exchange seen from the client and from the server laptop (one as sender, the other as receiver), with two different LAN addresses. Only one side shown: 1 point.
  - (1) Difference: the LAN IP addresses instead of `127.0.0.1` _(judgment)_
    - Expected: Client and server LAN addresses; optionally the `Host:` header with the server IP instead of `localhost`.

## Lease time (Bonus)

- Max Points: 2
- Graded on: Lab report (no tag)
- Rubric:
  - (1) The lease time and how it was found _(judgment)_
    - Expected: 60 s, from `ipconfig /all` (Lease Obtained / Expires), `ipconfig getpacket` (`lease_time 0x3c`) or DHCP option 51 in Wireshark.
  - (1) What a lease is, and one consequence each of a shorter and a longer lease _(judgment)_
    - Expected: A time-limited loan of an IP address by the DHCP server, renewed before it expires (renewal at T1 = 50 % is optional). Shorter: addresses return to the pool quickly, but more DHCP traffic. Longer: stable addresses and less traffic, but the pool can run out with stale leases.

## Analyse Modbus traffic

- Max Points: 3
- Graded on: Lab report (no tag)
- Rubric:
  - (1) The display filter shows only the Modbus traffic _(judgment)_
    - Expected: `modbus` or `modbus.func_code == 1`, with port 1502 decoded as Modbus/TCP.
  - (1) A Read Coils query and its function code _(judgment)_
    - Expected: A query shown in a capture (packet list, details, text excerpt or screenshot) with the function code 1 (Read Coils) is enough. Otherwise also reference 0, bit count 10 and the server laptop's LAN address on port 1502 is also ok. A a query to `127.0.0.1` (the client queries itself) scores 0.
  - (1) The response and its coil states _(judgment)_
    - Expected: A response in a capture (packet list, details, text excerpt or screenshot) with the function code 1 (Read Coils) is enough. Also the coil states are enough (LSB first, e.g. `0x4d` means coils 0, 2, 3 and 6 on). Otherwise also function code 1 and byte count 2.

## Map RPI MAC to IP

- Max Points: 3
- Graded on: Lab report (no tag)
- Rubric:
  - (1) The MAC address and the previous IP address of the Raspberry Pi _(judgment)_
    - Expected: From the Leases tab of the router: hostname `OTxx`, a MAC `d8:3a:dd:...` and an address of the pool. The MAC of the own laptop scores 0.
  - (1) A static mapping of the Raspberry Pi MAC to `192.168.1.4` _(judgment)_
    - Expected: Screenshot of the Static MAC/IP Mapping tab (ID, MAC, `192.168.1.4`), or the new address of the Raspberry Pi in the router or in the traffic. The Raspberry Pi missing from the Leases tab after the mapping is expected.
  - (1) HTTP traffic between the laptop and `192.168.1.4` _(judgment)_
    - Expected: Destination IP `192.168.1.4`, port 8050, destination MAC equal to the Raspberry Pi MAC of `mac`.

## DNS for webpage on RPI

- Max Points: 3
- Graded on: Lab report (no tag)
- Rubric:
  - (1) The DNS query and response for `dashboard.lan` _(judgment)_
    - Expected: `A dashboard.lan` from the laptop to `192.168.1.1` on UDP 53 and the response with the same transaction ID and the answer `192.168.1.4`. Chrome's extra `HTTPS` query is not required.
  - (1) The following HTTP traffic to the Raspberry Pi _(judgment)_
    - Expected: `GET /` to `192.168.1.4:8050` with `Host: dashboard.lan:8050`.
  - (1) The name resolution is explained in own words _(judgment)_
    - Expected: The browser asks the DNS server learned by DHCP (the router), which answers from its own host table (authoritative, TTL 0), then connects to the returned IP. Explaining the cache (no query on reload) is not required; a report with no DNS traffic gets the point only if it explains the cache.

## Report Quality

- Max Points: 3
- Graded on: Lab report (no tag)
- Rubric:
  - (1) Presence and quality of the personal summary (learning and difficulties) _(judgment)_
    - Expected: A closing section in own words on what was learned and which difficulties came up (and how they were solved). Only one of the two, or a recap of the results instead of the learning: 0.5. No summary: 0.
  - (1) The report follows the tasks of the handout, with authors, date and rack, and answers each question explicitly _(judgment)_
    - Expected: One section per task with its title, the authors, date and rack number at the top, and each question answered in the text (not only by a screenshot). A missing rack number is not deducted in 2026 (the handout does not ask for it). Missing answers already deducted in a task are not deducted again here.
  - (1) Screenshots are readable, focused and explained in the text, with precise technical wording _(judgment)_
    - Expected: Screenshots legible and cropped to the relevant packets and fields, numbered and referenced in the text; protocol and layer names, addresses and units used correctly. Mistakes already deducted in a task are not deducted again here.

## Not Assigned

- Install tools (0 points) — no deliverable
- Setup repository (0 points) — no deliverable (template repository, no code to write)
