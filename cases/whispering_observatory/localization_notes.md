FILE: case/localization_notes.md
CLASSIFICATION: DISCOVERABLE

# Localization Guide: The Whispering Observatory / Yerelleştirme Kılavuzu: Fısıltı Gözlemevi

This document provides the canonical English–Turkish localization standards to ensure internal consistency and natural linguistic flow across all game systems and character interactions.

---

## 1. Canonical Naming and Titles

### Character Registry
| ID | English Name | Turkish Name | Title/Occupation | Honorific (EN) | Honorific (TR) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `victim_01` | Alistair Thorne | Alistair Thorne | Head Astronomer | Dr. Thorne | Dr. Thorne |
| `suspect_01` | Elena Vance | Elena Vance | Lead Astrophysicist | Dr. Vance | Dr. Vance |
| `suspect_02` | Marcus Thorne | Marcus Thorne | Estranged Son | Marcus | Marcus Bey |
| `suspect_03` | Suna Aksoy | Suna Aksoy | Postdoctoral Researcher | Suna | Suna Hanım |
| `suspect_04` | Julian Vane | Julian Vane | Tech Benefactor | Mr. Vane | Julian Bey |
| `suspect_05` | Silas Reed | Silas Reed | Head of Security | Captain Reed | Kaptan Silas |
| `suspect_06` | Hugo Sterling | Hugo Sterling | Retired Colleague | Dr. Sterling | Dr. Sterling |

*Note: For `suspect_03`, Suna Aksoy is a Turkish name and remains identical in both languages.*

---

## 2. Case and Location Mapping

### Case Titles
*   **English:** The Whispering Observatory
*   **Turkish:** Fısıltı Gözlemevi

### Location Registry
| ID | English Label | Turkish Label |
| :--- | :--- | :--- |
| `location_01` | The Great Reflector Dome | Büyük Yansıtıcı Kubbesi |
| `location_02` | Central Control Room | Merkezi Kontrol Odası |
| `location_03` | The Mess Hall / Common Area | Yemekhane / Ortak Alan |
| `location_04` | Personal Quarters (West Wing) | Kişisel Odalar (Batı Kanadı) |
| `location_05` | Personal Quarters (East Wing) | Kişisel Odalar (Doğu Kanadı) |
| `location_06` | The Server Room / Comm-Link Hub | Sunucu Odası / İletişim Merkezi |
| `location_07` | The Oxygen Enrichment Plant | Oksijen Zenginleştirme Tesisi |
| `location_08` | The Outdoor Maintenance Catwalk | Dış Mekan Bakım İskelesi |

---

## 3. Clue Catalog Translations

| ID | English Clue Name | Turkish Clue Name |
| :--- | :--- | :--- |
| `clue_01` | Broken telescope calibration lens | Kırık teleskop kalibrasyon merceği |
| `clue_02` | Smudged logbook entry | Karalanmış kayıt defteri girişi |
| `clue_03` | Disconnected emergency radio | Devre dışı bırakılmış acil durum telsizi |
| `clue_04` | Torn photograph of 1998 expedition | 1998 seferine ait yırtık fotoğraf |
| `clue_05` | Trace of high-altitude medicine | Yüksek irtifa ilacı kalıntısı |
| `clue_06` | Suna’s nervous reaction | Suna’nın gergin tepkisi |
| `clue_07` | Silas’s missing master key | Silas’ın kayıp ana anahtarı |
| `clue_08` | Julian’s encrypted satellite phone | Julian’ın şifreli uydu telefonu |
| `clue_09` | Conflicting reports of the scream | Çığlık vaktine dair çelişkili ifadeler |
| `clue_10` | Damp wool coat | Nemli yün palto |
| `clue_11` | Deleted data logs | Silinmiş veri kayıtları |
| `clue_12` | Marcus's inheritance documents | Marcus’un miras belgeleri |
| `clue_13` | Hugo's trembling hands | Hugo’nun titreyen elleri |
| `clue_14` | Vial of poison | Zehir şişesi |
| `clue_15` | Locked door testimony | Kilitli kapıya dair ifade |
| `clue_16` | Audio recording of argument | Tartışmanın ses kaydı |
| `clue_17` | Footprints on the catwalk | İskeledeki ayak izleri |
| `clue_18` | Hugo’s false memory | Hugo’nun hatalı hafızası |

---

## 4. Emotional States and Response Modes

| State/Mode | English | Turkish | Tone Guidance |
| :--- | :--- | :--- | :--- |
| **State** | Calm | Sakin | Composed, cooperative, professional. |
| **State** | Uneasy | Huzursuz | Hesitant, uses fillers (uh, şey). |
| **State** | Defensive | Savunmacı | Short answers, aggressive or dismissive. |
| **State** | Cornered | Köşeye Sıkışmış | Panic, cold calculation, or emotional break. |
| **State** | Cooperative | İş Birlikçi | Helpful, providing details without pressure. |
| **Mode** | Truth | Doğru | Direct and factual. |
| **Mode** | Partial Truth | Kısmi Doğru | Omission of critical details. |
| **Mode** | Evasion | Kaçınma | Changing the subject or stalling. |
| **Mode** | Lie | Yalan | Fabricated facts from private files. |

---

## 5. Linguistic Rules and Formatting

### Capitalization and Punctuation
*   **English:** Standard sentence case. Proper nouns (Andean Peaks, Dr. Thorne) always capitalized. Use double quotation marks ("") for speech.
*   **Turkish:** Standard Turkish sentence case. Proper nouns receive apostrophes for suffixes (Thorne'un, Aksoy'u). Use double quotation marks ("") for speech; do not use the Turkish long dash (—) for dialogue in this system to maintain cross-platform consistency.

### Time and Date
*   **Time:** Use 24-hour format in both languages for technical logs (e.g., 22:45). In dialogue, use natural phrasing (EN: "Quarter to eleven"; TR: "On bire çeyrek kala").
*   **Date:** EN: Month Day, Year (October 14, 2026). TR: Day Month Year (14 Ekim 2026).

### Social Address (Sen vs. Siz)
Turkish character logic must follow strict social hierarchy:
*   **Siz (Formal):** Used by `suspect_05` (Silas) and `suspect_03` (Suna) toward everyone. `suspect_01` (Elena) uses *Siz* toward the detective.
*   **Sen (Informal):** Used by `suspect_02` (Marcus) when angry or dismissive. `suspect_06` (Hugo) may use it with the detective if a "Cooperative" bond is formed.

---

## 6. Character Voice Guidance

*   **suspect_01 (Elena Vance):**
    *   *EN:* Clinical, precise, academic. Rarely uses contractions.
    *   *TR:* Ciddi, akademik bir dil. Gereksiz kelimelerden kaçınır.
*   **suspect_02 (Marcus Thorne):**
    *   *EN:* Cynical, edgy, uses informal slang.
    *   *TR:* Alaycı, sokak ağzına yakın ama kaba değil.
*   **suspect_03 (Suna Aksoy):**
    *   *EN:* Nervous, polite, overly formal.
    *   *TR:* Çok nazik, çekingen ve resmi bir hitap şekli (Siz).
*   **suspect_05 (Silas Reed):**
    *   *EN:* Brief, military-esque, focused on facts.
    *   *TR:* Emir kipi içermeyen ama otoriter, net ve kısa cümleler.

---

## 7. Ambiguity and Prohibited Translations

*   **Term: "Bolt"**
    *   *Context:* The security mechanism on the dome door.
    *   *Correct TR:* **Sürgü** (Door bolt).
    *   *Prohibited TR:* *Civata* (Mechanical screw bolt). Using *civata* would distort the clue regarding the locked room.
*   **Term: "Discovery"**
    *   *Context:* The scientific breakthrough.
    *   *Correct TR:* **Buluş** or **Keşif**.
    *   *Prohibited TR:* *İcat* (Invention). Thorne discovered a phenomenon; he did not invent a machine.
*   **Term: "Catwalk"**
    *   *Correct TR:* **Bakım İskelesi** or **Yürüyüş Yolu**.
    *   *Prohibited TR:* *Podyum* (Fashion catwalk).

---

## 8. Glossary of Interrogation Terminology

| ID | English Term | Turkish Term |
| :--- | :--- | :--- |
| `term_alibi` | Alibi | Alibi / Uzaklık Kanıtı |
| `term_motive` | Motive | Güdü / Motivasyon |
| `term_witness` | Witness | Tanık |
| `term_evidence` | Evidence | Delil / Kanıt |
| `term_suspect` | Suspect | Şüpheli |
| `term_contradiction` | Contradiction | Çelişki |

---

## 9. Fallback Behavior
If a player provides a query mixing English and Turkish (e.g., "Silas'ın master key nerede?"):
1.  **Prioritize Language:** Respond in the language of the majority of the sentence or the last detected noun.
2.  **Terminology Sync:** Use the canonical Turkish terms even if the player used the English ID (e.g., if player says "clue_10", the character responds regarding the "nemli palto").
3.  **Stability:** Never switch languages mid-sentence.