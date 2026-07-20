FILE: case/contradiction_matrix.md
CLASSIFICATION: CHARACTER_PRIVATE

# Contradiction Matrix: The Whispering Observatory

This matrix identifies conflicts between suspect testimony and discovered evidence. Entries are classified by **Evidence Status** to ensure logical consistency. Only `PROVEN_CONTRADICTION` entries trigger emotional state transitions to **Cornered** or **Cooperative**.

---

### contradiction_01: Elena’s 22:45 Alibi
*   **Evidence Status:** INFERENCE_ONLY
*   **First Statement:** "I was in the Mess Hall (location_03) during the power flicker at 22:45, preparing tea."
*   **Conflicting Evidence:** clue_03 (Emergency radio wires severed in location_06 during the flicker).
*   **Characters Involved:** suspect_01 (Elena Vance).
*   **Related Clue IDs:** clue_03.
*   **Relevant Event IDs:** event_06.
*   **True Explanation:** Sabotage occurred at the same time as her claimed alibi. While clue_03 proves deliberate sabotage, it does not physically place Elena in location_06.
*   **Origin:** Killer Deception.
*   **Questions (EN/TR):** 
    *   "Can anyone verify you were in the Mess Hall at 10:45 PM?" / "Saat 22:45'te yemekhanede olduğunuzu doğrulayacak biri var mı?"
*   **Follow-up (EN/TR):** 
    *   "The radio was sabotaged exactly when the power flickered. It's a strange coincidence, isn't it?" / "Telsiz tam da güç kesintisi sırasında sabote edilmiş. Tuhaf bir tesadüf, değil mi?"
*   **Before Exposure (EN/TR):** "I was alone. The others were in their rooms or the wings." / "Yalnızdım. Diğerleri odalarında veya kanatlardaydı."
*   **State Transition:** NONE
*   **Does Not Prove:** That Elena performed the sabotage; only that her alibi is unverified and coincides with a criminal act.

---

### contradiction_02: Marcus’s 22:15 Alibi
*   **Evidence Status:** PROVEN_CONTRADICTION
*   **First Statement:** "I stayed in my room (location_04) from 10:00 PM onwards. I didn't see Alistair again."
*   **Conflicting Evidence:** clue_16 (Audio recording of the 22:15 argument in the corridor).
*   **Characters Involved:** suspect_02 (Marcus Thorne).
*   **Related Clue IDs:** clue_16.
*   **Relevant Event IDs:** event_05.
*   **True Explanation:** Marcus was in the West Wing corridor confronting his father. clue_16 proves the argument happened.
*   **Origin:** Fear / Shame.
*   **Questions (EN/TR):** 
    *   "Where were you at 10:15 PM?" / "Saat 22:15'te neredeydiniz?"
*   **Follow-up (EN/TR):** 
    *   "I have a recording of you shouting at your father in the hallway at that exact time. Why lie?" / "Tam o saatte koridorda babanıza bağırdığınızın kaydı var elimde. Neden yalan söylüyorsunuz?"
*   **Before Exposure (EN/TR):** "I told you, I was in my room, trying to sleep." / "Söyledim ya, odamdaydım, uyumaya çalışıyordum."
*   **After Exposure (EN/TR):** "Fine. We argued. He was a monster, and I wanted him to know it. I went back to my room afterward." / "Tamam. Tartıştık. O bir canavardı ve bunu bilmesini istedim. Sonra odama döndüm."
*   **State Transition:** Defensive to Cornered
*   **Does Not Prove:** Marcus's location during the murder window (23:00); clue_16 only establishes his presence at 22:15.

---

### contradiction_03: Elena’s "Inside Only" Claim
*   **Evidence Status:** PROVEN_CONTRADICTION
*   **First Statement:** "I have not been outside the facility since the storm began."
*   **Conflicting Evidence:** clue_10 (Damp coat in East Wing) and clue_17 (Footprints on location_08).
*   **Characters Involved:** suspect_01 (Elena Vance).
*   **Related Clue IDs:** clue_10, clue_17.
*   **Relevant Event IDs:** event_07.
*   **True Explanation:** The damp coat (clue_10) and fresh footprints matching facility-issue boots (clue_17) prove someone was outdoors during the storm.
*   **Origin:** Killer Deception.
*   **Questions (EN/TR):** 
    *   "Have you left the interior of the observatory tonight?" / "Bu gece gözlemevinin içinden dışarı çıktınız mı?"
*   **Follow-up (EN/TR):** 
    *   "Then why is your coat in the locker soaking wet and smelling of the storm?" / "O zaman dolaptaki paltonuz neden sırılsıklam ve fırtına kokuyor?"
*   **Before Exposure (EN/TR):** "Of course not. It's a blizzard out there." / "Tabii ki hayır. Dışarıda kar fırtınası var."
*   **After Exposure (EN/TR):** "The ventilation in the East Wing is poor. Condensation often dampens the lockers." / "Doğu Kanadı'nın havalandırması zayıf. Yoğuşma sık sık dolapları nemlendirir."
*   **State Transition:** Uneasy to Defensive
*   **Does Not Prove:** That Elena pushed Alistair; only that her claim of staying inside is physically contradicted by the state of her equipment.

---

### contradiction_04: Marcus’s Invitation
*   **Evidence Status:** PROVEN_CONTRADICTION
*   **First Statement:** "My father invited me here to witness his 'big moment'."
*   **Conflicting Evidence:** event_01 (Arrival logs showing he was an unscheduled visitor).
*   **Characters Involved:** suspect_02 (Marcus Thorne).
*   **Related Clue IDs:** None.
*   **Relevant Event IDs:** event_01.
*   **True Explanation:** Marcus crashed the summit to demand money; arrival logs prove he was not expected.
*   **Origin:** Shame.
*   **Questions (EN/TR):** 
    *   "Why did you come to the observatory today?" / "Bugün gözlemevine neden geldiniz?"
*   **Follow-up (EN/TR):** 
    *   "The manifest lists you as 'Unscheduled.' If he invited you, why wasn't your name on the list?" / "Manifesto sizi 'Planlanmamış' olarak listeliyor. Eğer sizi o davet ettiyse, adınız neden listede yoktu?"
*   **Before Exposure (EN/TR):** "He wanted me here. He sent a message." / "Burada olmamı istedi. Bir mesaj gönderdi."
*   **After Exposure (EN/TR):** "I didn't wait for an invite. He owed me, and I came to collect." / "Davetiye beklemedim. Bana borçluydu ve almaya geldim."
*   **State Transition:** Uneasy to Cooperative
*   **Does Not Prove:** Murderous intent; only that his reason for being present was based on a lie.

---

### contradiction_05: Silas’s "Everything is Secure" Claim
*   **Evidence Status:** PROVEN_CONTRADICTION
*   **First Statement:** "All security equipment is accounted for. Nothing is missing."
*   **Conflicting Evidence:** clue_02 (Smudged log) and clue_07 (Missing master key).
*   **Characters Involved:** suspect_05 (Silas Reed).
*   **Related Clue IDs:** clue_02, clue_07.
*   **Relevant Event IDs:** event_03.
*   **True Explanation:** The master key (clue_07) was stolen; clue_02 proves Silas tried to hide the theft.
*   **Origin:** Shame / Protection.
*   **Questions (EN/TR):** 
    *   "Is the facility perimeter fully secure?" / "Tesis çevresi tamamen güvenli mi?"
*   **Follow-up (EN/TR):** 
    *   "The master key dock is empty, Silas. What did you scribble out in the logbook at 11:00 AM?" / "Ana anahtar yuvası boş, Silas. Sabah 11:00'de kayıt defterinde neyi karaladınız?"
*   **Before Exposure (EN/TR):** "I run a tight ship. All equipment is present." / "İşimi sıkı tutarım. Tüm ekipmanlar yerinde."
*   **After Exposure (EN/TR):** "I... I lost it during the morning sweep. I didn't want the board to think I'd failed my post." / "Ben... sabah taraması sırasında kaybettim. Yönetim kurulunun görevimde başarısız olduğumu düşünmesini istemedim."
*   **State Transition:** Defensive to Cornered
*   **Does Not Prove:** That Silas could not access relevant routes; as security, he may possess alternate access methods or overrides despite the missing key.

---

### contradiction_06: Hugo’s 23:00 Weather Claim
*   **Evidence Status:** PROVEN_CONTRADICTION
*   **First Statement:** "There was a total whiteout at 11:00 PM. Visibility was zero."
*   **Conflicting Evidence:** clue_18 (Automated sensors record a weather lull at 23:00).
*   **Characters Involved:** suspect_06 (Hugo Sterling).
*   **Related Clue IDs:** clue_18.
*   **Relevant Event IDs:** event_07.
*   **True Explanation:** Sensors prove visibility was clear during the murder window; Hugo is providing false testimony.
*   **Origin:** Protection.
*   **Questions (EN/TR):** 
    *   "What did you see from your window at 11:00 PM?" / "Saat 23:00'te pencerenizden ne gördünüz?"
*   **Follow-up (EN/TR):** 
    *   "The automated sensors show a lull in the storm at exactly that time. Why claim it was a whiteout?" / "Otomatik sensörler tam o sırada fırtınada bir durulma gösteriyor. Neden kar körlüğü olduğunu iddia ediyorsunuz?"
*   **Before Exposure (EN/TR):** "Nothing but snow. Absolute chaos." / "Kardan başka bir şey yoktu. Tam bir kaos."
*   **After Exposure (EN/TR):** "My eyes... perhaps they deceived me. The glare on the glass can be tricky." / "Gözlerim... belki beni yanılttılar. Camdaki parlama aldatıcı olabilir."
*   **State Transition:** Uneasy to Defensive
*   **Does Not Prove:** Who Hugo is protecting; only that he is deliberately misrepresenting the visibility during the murder window.

---

### contradiction_07: Julian’s Isolation Claim
*   **Evidence Status:** PROVEN_CONTRADICTION
*   **First Statement:** "I have no way to communicate with the outside world. I'm as stranded as you."
*   **Conflicting Evidence:** clue_08 (Julian’s encrypted satellite phone).
*   **Characters Involved:** suspect_04 (Julian Vane).
*   **Related Clue IDs:** clue_08.
*   **Relevant Event IDs:** event_09.
*   **True Explanation:** Julian possesses a working satellite phone, contradicting his claim of total isolation.
*   **Origin:** Deliberate Deception.
*   **Questions (EN/TR):** 
    *   "Have you attempted to call for help?" / "Yardım çağırmaya çalıştınız mı?"
*   **Follow-up (EN/TR):** 
    *   "I found the satellite phone in your suite. It's fully functional, isn't it?" / "Süitinizde uydu telefonunu buldum. Tamamen çalışır durumda, değil mi?"
*   **Before Exposure (EN/TR):** "I wish I could. My companies are probably panicking." / "Keşke yapabilsem. Şirketlerim muhtemelen panik içindedir."
*   **After Exposure (EN/TR):** "It is for private business only. I have non-disclosure agreements that prevent me from using it for general purposes." / "O sadece özel işler için. Genel amaçlar için kullanmamı engelleyen gizlilik sözleşmelerim var."
*   **State Transition:** Calm to Uneasy
*   **Does Not Prove:** Direct involvement in the murder; only that he is protecting corporate interests over facility transparency.

---

### contradiction_08: Elena’s "Manual Bolt" Claim
*   **Evidence Status:** PROVEN_CONTRADICTION
*   **First Statement:** "Alistair must have engaged the mechanical bolt from inside the dome."
*   **Conflicting Evidence:** clue_11 (Log entry recording the remote bolt command at 23:08).
*   **Characters Involved:** suspect_01 (Elena Vance).
*   **Related Clue IDs:** clue_11, clue_15.
*   **Relevant Event IDs:** event_07.
*   **True Explanation:** clue_11 proves the bolt was engaged via a remote command under Elena's ID, contradicting the claim of a manual action.
*   **Origin:** Killer Deception.
*   **Questions (EN/TR):** 
    *   "How was the dome door locked?" / "Kubbe kapısı nasıl kilitlendi?"
*   **Follow-up (EN/TR):** 
    *   "The terminal logs show an 'Emergency Bolt' command was sent from the control room at 11:08 PM. Why suggest it was manual?" / "Terminal kayıtları, saat 23:08'de kontrol odasından bir 'Acil Durum Sürgüsü' komutu gönderildiğini gösteriyor. Neden manuel olduğunu öne sürüyorsunuz?"
*   **Before Exposure (EN/TR):** "The bolt is mechanical. It requires someone inside the room." / "Sürgü mekaniktir. Odada birinin olmasını gerektirir."
*   **After Exposure (EN/TR):** "Ghost commands are common in legacy systems. The power surge at 10:45 likely triggered a delayed execution." / "Eski sistemlerde hayalet komutlar yaygındır. Saat 22:45'teki güç dalgalanması muhtemelen gecikmeli bir yürütmeyi tetikledi."
*   **State Transition:** Defensive to Cornered
*   **Does Not Prove:** That Elena was at the terminal (someone could have used her ID), though it strongly points to technical manipulation.

---

### contradiction_09: Silas’s Claim about the Key
*   **Evidence Status:** PROVEN_CONTRADICTION
*   **First Statement:** "No security equipment was stolen during my watch."
*   **Conflicting Evidence:** clue_07 (The master key is missing).
*   **Characters Involved:** suspect_05 (Silas Reed).
*   **Related Clue IDs:** clue_07.
*   **Relevant Event IDs:** event_03.
*   **True Explanation:** The key is physically absent from its dock; Silas is lying to hide his failure.
*   **Origin:** Fear.
*   **Questions (EN/TR):** 
    *   "Did anyone steal the master maintenance key?" / "Ana bakım anahtarını kimse çaldı mı?"
*   **Follow-up (EN/TR):** 
    *   "The dock is empty, Silas. When did you realize it was gone?" / "Yuva boş, Silas. Gittiğini ne zaman fark ettiniz?"
*   **Before Exposure (EN/TR):** "Impossible. I check the inventory every twelve hours." / "İmksansız. Envanteri her on iki saatte bir kontrol ederim."
*   **After Exposure (EN/TR):** "I noticed it was missing around noon. I thought Alistair had taken it for a calibration walk." / "Öğle civarı eksik olduğunu fark ettim. Alistair'in kalibrasyon yürüyüşü için aldığını sandım."
*   **State Transition:** Uneasy to Defensive
*   **Does Not Prove:** That Silas knows who took the key; only that he covered up its disappearance.

---

### contradiction_10: Suna’s Medicine Call Claim
*   **Evidence Status:** INFERENCE_ONLY
*   **First Statement:** "I went to the dome because Dr. Thorne called me to deliver his medicine."
*   **Conflicting Evidence:** event_07 (Time of death was 23:00).
*   **Characters Involved:** suspect_03 (Suna Aksoy).
*   **Related Clue IDs:** clue_05, clue_09.
*   **Relevant Event IDs:** event_07, event_08.
*   **True Explanation:** Suna was found at the door at 23:30 (clue_05). While death occurred at 23:00, her claim of a "call" is an inference-based suspicion because Alistair was already deceased.
*   **Origin:** Fear / Shame.
*   **Questions (EN/TR):** 
    *   "Why did you bring the medicine to the dome?" / "İlacı kubbeye neden getirdiniz?"
*   **Follow-up (EN/TR):** 
    *   "What evidence can confirm that Alistair asked you to bring the medicine?" / "Alistair'ın ilacı getirmenizi istediğini hangi kanıt doğrulayabilir?"
*   **Before Exposure (EN/TR):** "I... I am sure. He sounded desperate." / "Ben... eminim. Sesi çaresiz geliyordu."
*   **State Transition:** NONE
*   **Does Not Prove:** Suna's location at 23:00; clue_05 only establishes her presence near the body at 23:30.

---

### contradiction_11: Hugo’s Argument Witness Claim
*   **Evidence Status:** INFERENCE_ONLY
*   **First Statement:** "I was resting in my room (location_04) and heard nothing unusual at 10:15 PM."
*   **Conflicting Evidence:** clue_16 (Recording proves a loud argument took place in the corridor).
*   **Characters Involved:** suspect_06 (Hugo Sterling).
*   **Related Clue IDs:** clue_16.
*   **Relevant Event IDs:** event_05.
*   **True Explanation:** Although clue_16 proves the argument between Marcus and Alistair occurred, it does not prove Hugo definitely heard it or witnessed it, despite his proximity.
*   **Origin:** Protection.
*   **Questions (EN/TR):** 
    *   "Did you hear any shouting in the West Wing hallway tonight?" / "Bu gece Batı Kanadı koridorunda herhangi bir bağırma duydunuz mu?"
*   **Follow-up (EN/TR):** 
    *   "The recording is very clear, Hugo. It was a heated argument. Are you sure you heard nothing?" / "Kayıt çok net, Hugo. Hararetli bir tartışmaydı. Hiçbir şey duymadığınızdan emin misiniz?"
*   **Before Exposure (EN/TR):** "The wind rattles the vents in my room. It's hard to distinguish voices." / "Odamdaki havalandırmalar rüzgardan sarsılıyor. Sesleri ayırt etmek zor."
*   **State Transition:** NONE
*   **Does Not Prove:** That Hugo witnessed the argument; only that his claim of silence is questionable given the recorded volume.

---

### contradiction_12: Suna’s "Data is Fine" Claim
*   **Evidence Status:** INFERENCE_ONLY
*   **First Statement:** "The discovery data is perfect. There are no errors."
*   **Conflicting Evidence:** clue_06 (Suna’s behavioral anxiety when data is mentioned).
*   **Characters Involved:** suspect_03 (Suna Aksoy).
*   **Related Clue IDs:** clue_06.
*   **Relevant Event IDs:** event_02.
*   **True Explanation:** Suna's extreme anxiety (clue_06) suggests she is lying about the data's integrity, but it is not physical proof of fraud.
*   **Origin:** Shame.
*   **Questions (EN/TR):** 
    *   "Is there anything wrong with the discovery data?" / "Buluş verilerinde yanlış bir şey var mı?"
*   **Follow-up (EN/TR):** 
    *   "Every time we discuss the telescope logs, you look like you're going to panic. Why?" / "Teleskop kayıtlarını her tartıştığımızda panikleyecek gibi görünüyorsunuz. Neden?"
*   **Before Exposure (EN/TR):** "It is a monumental achievement for the observatory." / "Gözlemevi için anıtsal bir başarı."
*   **State Transition:** NONE
*   **Does Not Prove:** That data fraud was the motive for murder; only that Suna has a professional secret she is protecting.

---

### contradiction_13: Marcus’s Financial Claim
*   **Evidence Status:** PROVEN_CONTRADICTION
*   **First Statement:** "I don't care about my father's money. I have my own life."
*   **Conflicting Evidence:** clue_12 (Inheritance and debt documents found in his luggage).
*   **Characters Involved:** suspect_02 (Marcus Thorne).
*   **Related Clue IDs:** clue_12.
*   **Relevant Event IDs:** event_01.
*   **True Explanation:** The documents prove Marcus was investigating his father's estate and is in severe debt.
*   **Origin:** Shame / Motive.
*   **Questions (EN/TR):** 
    *   "Are you in any financial trouble, Marcus?" / "Herhangi bir maddi sıkıntın var mı, Marcus?"
*   **Follow-up (EN/TR):** 
    *   "I found the debt collection notices and the estate papers. You came here for a payout, didn't you?" / "Borç tahsilat bildirimlerini ve veraset belgelerini buldum. Buraya bir ödeme almak için geldin, değil mi?"
*   **Before Exposure (EN/TR):** "My finances are my business. I came here for closure." / "Maddi durumum beni ilgilendirir. Buraya defteri kapatmak için geldim."
*   **After Exposure (EN/TR):** "I'm drowning. He lived like a king while my mother lived in poverty. I wanted what was owed to us." / "Batıyorum. Annem yoksulluk içinde yaşarken o bir kral gibi yaşadı. Bize borçlu olunanı istedim."
*   **State Transition:** Uneasy to Cooperative
*   **Does Not Prove:** Opportunity or act of murder; only that a strong financial motive exists.

---

### contradiction_14: Hugo’s 1998 Claim
*   **Evidence Status:** INFERENCE_ONLY
*   **First Statement:** "The 1998 expedition was a success. Nothing unusual occurred."
*   **Conflicting Evidence:** clue_04 (Torn photo) and clue_13 (Hugo's psychosomatic trembling).
*   **Characters Involved:** suspect_06 (Hugo Sterling).
*   **Related Clue IDs:** clue_04, clue_13.
*   **Relevant Event IDs:** event_01.
*   **True Explanation:** The physical artifacts suggest a hidden trauma, but do not prove a specific crime or lie about the trip's status.
*   **Origin:** Shame.
*   **Questions (EN/TR):** 
    *   "Tell me about the 1998 expedition." / "1998 seferinden bahset bana."
*   **Follow-up (EN/TR):** 
    *   "You start shaking every time that year is mentioned, Hugo. And this photo... why is Alistair's face torn out?" / "O yıldan her bahsedildiğinde titremeye başlıyorsun, Hugo. Ve bu fotoğraf... Alistair'in yüzü neden yırtılmış?"
*   **Before Exposure (EN/TR):** "It was a standard field mission. We were younger then." / "Standart bir saha göreviydi. O zamanlar daha gençtik."
*   **State Transition:** NONE
*   **Does Not Prove:** That Hugo has present-day murderous intent; clue_04 only establishes a past secret.

---

### contradiction_15: Silas’s Radio Failure Claim
*   **Evidence Status:** PROVEN_CONTRADICTION
*   **First Statement:** "The radio array failed due to the storm's intensity."
*   **Conflicting Evidence:** clue_03 (Severed wires in location_06).
*   **Characters Involved:** suspect_05 (Silas Reed).
*   **Related Clue IDs:** clue_03.
*   **Relevant Event IDs:** event_06.
*   **True Explanation:** clue_03 proves deliberate sabotage; Silas is lying to avoid admitting a security breach occurred.
*   **Origin:** Protection / Reputation.
*   **Questions (EN/TR):** 
    *   "Is the radio failure definitely weather-related?" / "Telsiz arızası kesinlikle hava durumuyla mı ilgili?"
*   **Follow-up (EN/TR):** 
    *   "The wires were cut with a tool, Silas. This was sabotage. Why say it was the storm?" / "Kablolar bir aletle kesilmiş, Silas. Bu sabotajdı. Neden fırtına olduğunu söylediniz?"
*   **Before Exposure (EN/TR):** "High-altitude winds can snap cables like string." / "Yüksek irtifa rüzgarları kabloları ip gibi koparabilir."
*   **After Exposure (EN/TR):** "I didn't want a panic. If someone is inside cutting wires, we're in real danger. I was trying to find out who had the access." / "Panik olsun istemedim. Eğer içeriden biri kabloları kesiyorsa, gerçek bir tehlike içindeyiz demektir. Kimin erişimi olduğunu bulmaya çalışıyordum."
*   **State Transition:** Defensive to Cornered
*   **Does Not Prove:** Who performed the sabotage; clue_03 only proves that the damage was non-accidental.