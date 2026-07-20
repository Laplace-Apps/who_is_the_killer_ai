FILE: case/locations.md
CLASSIFICATION: DISCOVERABLE

# Observatory Location Directory

### location_01: The Great Reflector Dome (Body Recovery Scene)
*   **Description (English):** A massive, hemispherical chamber housing the primary 8-meter optical telescope. The air is kept at ambient mountain temperatures to prevent thermal distortion of the glass. The telescope towers over a circular floor of polished concrete. This is where Dr. Thorne's body was discovered at the base of the instrument.
*   **Description (Turkish):** 8 metrelik ana optik teleskopu barındıran devasa, yarım küre şeklinde bir oda. Camın termal bozulmasını önlemek için hava, dağ sıcaklığında tutulur. Teleskop, cilalı betondan dairesel bir zeminin üzerinde yükselir. Dr. Thorne'un cesedi bu aletin kaidesinde bulunmuştur.
*   **Entrances and Exits:**
    *   Internal: Main pressurized door leading to the Central Control Room (location_02).
    *   External: Emergency maintenance airlock leading to the Outdoor Maintenance Catwalk (location_08).
*   **Access:** Restricted to research staff (suspect_01, suspect_03, suspect_06) and Security (suspect_05).
*   **Visibility:** Dimly lit by red navigation lights. The primary aperture is a massive sliding panel in the roof.
*   **Acoustics:** High ceiling causes significant echoes. High-altitude winds can be heard whistling against the structure.
*   **Lighting:** Dim red LEDs; natural starlight when the aperture is open.
*   **Relevant Objects:** The primary 8-meter telescope, the rotating floor mechanism, the manual calibration station.
*   **Authorized Characters:** victim_01, suspect_01, suspect_03, suspect_05, suspect_06.
*   **Physical Evidence:** clue_01 (broken lens), victim_01’s body, clue_05 (traces of medicine).
*   **Reveal Conditions:** Discovery of the body (event_08) opens this location for investigation.
*   **False Assumptions:** The presence of the body here initially led witnesses to believe the dome interior was the site of the fatal struggle.

### location_02: Central Control Room
*   **Description (English):** The technological "brain" of the observatory. It is a horseshoe-shaped room filled with high-resolution monitors, server terminals, and the primary navigation console for the telescope.
*   **Description (Turkish):** Gözlemevinin teknolojik "beyni". Yüksek çözünürlüklü monitörler, sunucu terminalleri ve teleskop için ana navigasyon konsolu ile dolu, at nalı şeklinde bir odadır.
*   **Entrances and Exits:** Hallway to the Common Area (location_03); Pressurized door to the Dome (location_01).
*   **Access:** All scientific personnel and security.
*   **Visibility:** Bright, constant fluorescent lighting.
*   **Acoustics:** Constant hum of cooling fans and server racks.
*   **Relevant Objects:** The master console, environmental override panel, telescope navigation interface.
*   **Authorized Characters:** suspect_01, suspect_03, suspect_04, suspect_05, suspect_06.
*   **Physical Evidence:** clue_11 (deleted data logs on the console).
*   **Reveal Conditions:** Accessible from the start of the investigation.

### location_03: The Mess Hall / Common Area
*   **Description (English):** A spacious social hub designed for long-term stays. It features a kitchen, large dining tables, and panoramic windows that are currently obscured by thick ice and snow.
*   **Description (Turkish):** Uzun süreli konaklamalar için tasarlanmış geniş bir sosyal merkez. Bir mutfak, büyük yemek masaları ve şu anda kalın buz ve karla kaplı panoramik pencereler içerir.
*   **Entrances and Exits:** Main elevator bank; Hallways to East and West wings.
*   **Access:** All personnel and guests.
*   **Acoustics:** Open space; conversations at the tables can often be heard from the kitchen.
*   **Relevant Objects:** The coffee station, kitchen cabinets, communal digital notice board.
*   **Authorized Characters:** All suspects.
*   **Physical Evidence:** clue_14 (poison vial in the kitchen).
*   **Reveal Conditions:** Accessible from the start of the investigation.

### location_04: Personal Quarters (West Wing)
*   **Description (English):** A corridor of soundproofed suites. This wing houses the honorary guests and non-staff residents.
*   **Description (Turkish):** Ses yalıtımlı süitlerden oluşan bir koridor. Bu kanat onur konuklarını ve personel olmayan sakinleri barındırır.
*   **Entrances and Exits:** Hallway to Common Area (location_03).
*   **Access:** Assigned to suspect_02, suspect_04, suspect_06.
*   **Acoustics:** Heavily soundproofed suites; however, loud raised voices in the hallway can still be detected through the door seals.
*   **Relevant Objects:** Private safes, personal luggage, individual climate controls.
*   **Authorized Characters:** suspect_02, suspect_04, suspect_06.
*   **Physical Evidence:** clue_04 (torn photo in room of suspect_06), clue_12 (documents in room of suspect_02).

### location_05: Personal Quarters (East Wing)
*   **Description (English):** The staff living area. This wing contains a secured sub-area that serves as Captain Reed's security workspace, containing monitors and equipment docks.
*   **Description (Turkish):** Personel yaşam alanı. Bu kanat, Kaptan Reed'in monitörler ve ekipman yuvaları içeren güvenli bir çalışma alanı olarak hizmet veren alt bölümünü içerir.
*   **Entrances and Exits:** Hallway to Common Area (location_03).
*   **Access:** Assigned to suspect_01, suspect_03, suspect_05.
*   **Acoustics:** Standard dormitory-style acoustics.
*   **Relevant Objects:** Security equipment dock, staff lockers, internal facility monitors.
*   **Authorized Characters:** suspect_01, suspect_03, suspect_05.
*   **Physical Evidence:** clue_02 (Silas’s logbook), clue_10 (damp coat in a staff locker).
*   **Reveal Conditions:** Silas's workspace is restricted until he permits entry or professional pressure is applied.

### location_06: The Server Room / Comm-Link Hub
*   **Description (English):** A freezing, windowless room filled with racks of processing units and the hardware for the long-range radio array. It contains the entrance to a maintenance tunnel known as Service Shaft C.
*   **Description (Turkish):** İşlem birimleri rafları ve uzun menzilli telsiz dizisi donanımıyla dolu, dondurucu, penceresiz bir oda. Servis Şaftı C olarak bilinen bir bakım tünelinin girişini içerir.
*   **Entrances and Exits:** Secured door from the main hallway; Entrance to **Service Shaft C** (which connects only to location_08).
*   **Access:** Restricted to Lead Astrophysicist (suspect_01) and Security (suspect_05).
*   **Visibility:** Low; lit mainly by the blinking status lights of the server racks.
*   **Acoustics:** Very loud white noise from industrial cooling systems.
*   **Relevant Objects:** The radio transmitter, server mainframe, maintenance ladder for Shaft C.
*   **Authorized Characters:** suspect_01, suspect_05.
*   **Physical Evidence:** clue_03 (disconnected radio).

### location_07: The Oxygen Enrichment Plant
*   **Description (English):** A high-security industrial zone containing the pressure tanks and scrubbing systems required to maintain life support at 5,000 meters.
*   **Description (Turkish):** 5.000 metrede yaşam desteğini sürdürmek için gereken basınç tanklarını ve temizleme sistemlerini içeren yüksek güvenlikli bir endüstriyel bölge.
*   **Entrances and Exits:** Heavy industrial door; emergency release valve.
*   **Access:** Restricted to suspect_05 and specialized maintenance staff.
*   **Authorized Characters:** suspect_05.
*   **Lighting:** Harsh industrial yellow lighting.

### location_08: The Outdoor Maintenance Catwalk (Murder Site)
*   **Description (English):** A narrow, metal-grated walkway encircling the dome's exterior. It is exposed to the extreme Andean elements and situated above a sheer 25-meter drop. This is the actual site where the struggle occurred, positioned directly above the telescope's open aperture.
*   **Description (Turkish):** Kubbenin dışını çevreleyen dar, metal ızgaralı bir yürüyüş yolu. Ekstrem And Dağları elementlerine maruz kalır ve 25 metrelik dik bir uçurumun üzerinde yer alır. Teleskobun açık açıklığının tam üzerinde yer alan bu bölge, gerçek boğuşmanın gerçekleştiği yerdir.
*   **Entrances and Exits:** Dome Airlock (to location_01); **Service Shaft C** exit (which connects only to location_06).
*   **Visibility:** Extremely poor due to the storm; visibility depends entirely on localized weather lulls.
*   **Acoustics:** The wind is deafening; internal sounds are rarely heard unless the airlock is open.
*   **Relevant Objects:** The telescope aperture opening, emergency railing, safety harness hooks.
*   **Authorized Characters:** suspect_05, victim_01, suspect_01.
*   **Physical Evidence:** clue_17 (footprints found near the aperture).