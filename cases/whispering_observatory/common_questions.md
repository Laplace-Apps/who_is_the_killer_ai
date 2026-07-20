FILE: case/common_questions.md
CLASSIFICATION: DISCOVERABLE

# Common Interrogation Intents: The Whispering Observatory

This file defines the interaction logic for the AI suspects. These intents represent the player's underlying goals when asking free-form questions. 

---

### Group 1: Identity and Background

**intent_identity_01**
*   **Description:** Basic introduction and role at the facility.
*   **English Phrasings:** "Who are you?", "What is your job here?", "Tell me about yourself."
*   **Turkish Phrasings:** "Kimsiniz?", "Buradaki göreviniz nedir?", "Kendinizden bahsedin."
*   **Knowledge Category:** Public
*   **Answer Length:** Short

**intent_identity_02**
*   **Description:** Specific reason for being at the observatory during the storm.
*   **English Phrasings:** "Why are you at Andean Peaks?", "What brought you to this summit?", "Why were you invited?"
*   **Turkish Phrasings:** "Neden Andean Peaks'tesiniz?", "Sizi bu zirveye ne getirdi?", "Neden davet edildiniz?"
*   **Knowledge Category:** Public / Discoverable
*   **Answer Length:** Medium

**intent_identity_03**
*   **Description:** Professional background or expertise.
*   **English Phrasings:** "What is your area of study?", "How long have you been an astronomer?", "What's your experience?"
*   **Turkish Phrasings:** "Uzmanlık alanınız nedir?", "Ne zamandır gökbilimcisiniz?", "Deneyiminiz nedir?"
*   **Knowledge Category:** Public
*   **Answer Length:** Medium

**intent_identity_04**
*   **Description:** Inquiring about the character's emotional state regarding the isolation.
*   **English Phrasings:** "Are you afraid of the storm?", "How are you handling the lockdown?", "Are you nervous?"
*   **Turkish Phrasings:** "Fırtınadan korkuyor musunuz?", "Karantina ile nasıl başa çıkıyorsunuz?", "Gergin misiniz?"
*   **Knowledge Category:** Public
*   **Answer Length:** Short

**intent_identity_05**
*   **Description:** History with the facility.
*   **English Phrasings:** "How long have you lived here?", "Is this your first time at the observatory?", "When did you first arrive?"
*   **Turkish Phrasings:** "Ne zamandır burada yaşıyorsunuz?", "Gözlemevine ilk gelişiniz mi?", "Buraya ilk ne zaman geldiniz?"
*   **Knowledge Category:** Public
*   **Answer Length:** Short

---

### Group 2: Relationship with the Victim

**intent_relation_01**
*   **Description:** General opinion of Dr. Alistair Thorne.
*   **English Phrasings:** "What did you think of Alistair?", "Was Dr. Thorne a good man?", "How was your relationship with the victim?"
*   **Turkish Phrasings:** "Alistair hakkında ne düşünüyordunuz?", "Dr. Thorne iyi biri miydi?", "Maktul ile ilişkiniz nasıldı?"
*   **Knowledge Category:** Public / Discoverable
*   **Answer Length:** Medium

**intent_relation_02**
*   **Description:** Knowledge of Alistair's discovery.
*   **English Phrasings:** "What do you know about his discovery?", "Was the breakthrough announcement real?", "Did you help with his research?"
*   **Turkish Phrasings:** "Keşfi hakkında ne biliyorsunuz?", "Çığır açan buluş duyurusu gerçek miydi?", "Araştırmasına yardım ettiniz mi?"
*   **Knowledge Category:** Discoverable
*   **Answer Length:** Medium

**intent_relation_03**
*   **Description:** Professional conflicts with the victim.
*   **English Phrasings:** "Did you ever argue with Alistair?", "Did he treat you well professionally?", "Was there any jealousy?"
*   **Turkish Phrasings:** "Alistair ile hiç tartıştınız mı?", "Size profesyonel anlamda iyi davranır mıydı?", "Herhangi bir kıskançlık var mıydı?"
*   **Knowledge Category:** Discoverable / Character Private
*   **Answer Length:** Medium

**intent_relation_04**
*   **Description:** Knowledge of the 1998 expedition.
*   **English Phrasings:** "What happened in 1998?", "Tell me about the previous expedition.", "Was there a secret in the past?"
*   **Turkish Phrasings:** "1998'de ne oldu?", "Önceki seferden bahset.", "Geçmişte bir sır var mıydı?"
*   **Knowledge Category:** Character Private
*   **Required Evidence:** clue_04
*   **Answer Length:** Medium

**intent_relation_05**
*   **Description:** Personal grievances or family history with Alistair.
*   **English Phrasings:** "Is there family resentment here?", "Did Alistair owe you something?", "Was there a private debt?"
*   **Turkish Phrasings:** "Ailevi bir kırgınlık mı var?", "Alistair'in size bir borcu var mıydı?", "Özel bir borç var mıydı?"
*   **Knowledge Category:** Character Private
*   **Answer Length:** Medium

---

### Group 3: Murder-Night Whereabouts

**intent_whereabouts_01**
*   **Description:** General location during the murder window (22:00 - 23:45).
*   **English Phrasings:** "Where were you last night?", "What were you doing at 11:00 PM?", "Tell me your movements."
*   **Turkish Phrasings:** "Dün gece neredeydiniz?", "Saat 23:00'te ne yapıyordunuz?", "Hareketlerinizi anlatın."
*   **Knowledge Category:** Public / Discoverable
*   **Answer Length:** Medium

**intent_whereabouts_02**
*   **Description:** Specific location at 22:45 (the power flicker).
*   **English Phrasings:** "Where were you when the lights flickered?", "What did you do during the blackout?", "Did you see anyone during the power surge?"
*   **Turkish Phrasings:** "Işıklar titrediğinde neredeydiniz?", "Karartma sırasında ne yaptınız?", "Güç dalgalanması sırasında kimseyi gördünüz mü?"
*   **Knowledge Category:** Discoverable
*   **Answer Length:** Medium

**intent_whereabouts_03**
*   **Description:** Specific location at 23:00 (the time of the scream).
*   **English Phrasings:** "Where were you when the scream happened?", "Did you hear the shout at 23:00?", "What were you doing at exactly 11:00 PM?"
*   **Turkish Phrasings:** "Çığlık atıldığında neredeydiniz?", "Saat 23:00'teki bağırmayı duydunuz mu?", "Tam olarak gece 11'de ne yapıyordunuz?"
*   **Knowledge Category:** Discoverable
*   **Answer Length:** Medium

**intent_whereabouts_04**
*   **Description:** Presence in the Central Control Room (location_02).
*   **English Phrasings:** "Were you in the control room last night?", "When was the last time you used a terminal?", "Did you access the servers?"
*   **Turkish Phrasings:** "Dün gece kontrol odasında mıydınız?", "En son ne zaman bir terminal kullandınız?", "Sunuculara eriştiniz mi?"
*   **Knowledge Category:** Discoverable / Character Private
*   **Answer Length:** Medium

**intent_whereabouts_05**
*   **Description:** Presence near the Server Room (location_06).
*   **English Phrasings:** "Did you go near the server room?", "Why were you in the comm-link hub?", "Were you in the basement levels?"
*   **Turkish Phrasings:** "Sunucu odasının yakınına gittiniz mi?", "Neden iletişim merkezindeydiniz?", "Bodrum katlarında mıydınız?"
*   **Knowledge Category:** Character Private
*   **Answer Length:** Medium

---

### Group 4: Alibi

**intent_alibi_01**
*   **Description:** Asking for an alibi witness.
*   **English Phrasings:** "Can anyone vouch for you?", "Who saw you in your room?", "Was anyone with you?"
*   **Turkish Phrasings:** "Size kim kefil olabilir?", "Sizi odanızda kim gördü?", "Yanınızda kimse var mıydı?"
*   **Knowledge Category:** Discoverable
*   **Answer Length:** Short

**intent_alibi_02**
*   **Description:** Questioning the strength of their alibi.
*   **English Phrasings:** "That alibi is very convenient.", "Why were you alone?", "It seems like nobody can confirm your location."
*   **Turkish Phrasings:** "Bu alibi çok müsait.", "Neden yalnızdınız?", "Görünüşe göre kimse yerinizi teyit edemiyor."
*   **Knowledge Category:** Discoverable
*   **Answer Length:** Medium

**intent_alibi_03**
*   **Description:** Asking about Alistair's alibi/whereabouts before death.
*   **English Phrasings:** "When did you last see Alistair alive?", "Where was the victim going when you saw him?", "What was Alistair doing at 22:00?"
*   **Turkish Phrasings:** "Alistair'i en son ne zaman canlı gördünüz?", "Onu gördüğünüzde maktul nereye gidiyordu?", "Alistair saat 22:00'de ne yapıyordu?"
*   **Knowledge Category:** Public / Discoverable
*   **Answer Length:** Medium

---

### Group 5: Motive

**intent_motive_01**
*   **Description:** Asking if the suspect had a reason to want the victim dead.
*   **English Phrasings:** "Why would you want him dead?", "Did you benefit from his death?", "What was your motive?"
*   **Turkish Phrasings:** "Onun ölmesini neden isteyesiniz?", "Ölümünden bir çıkarınız oldu mu?", "Motifiniz neydi?"
*   **Knowledge Category:** Discoverable / Character Private
*   **Answer Length:** Medium

**intent_motive_02**
*   **Description:** Asking about financial gain or inheritance.
*   **English Phrasings:** "Are you mentioned in his will?", "Will you get his research funding now?", "Was money a factor?"
*   **Turkish Phrasings:** "Vasiyetinde adınız geçiyor mu?", "Araştırma fonunu şimdi siz mi alacaksınız?", "Para bir etken miydi?"
*   **Knowledge Category:** Character Private
*   **Required Evidence:** clue_12
*   **Answer Length:** Medium

**intent_motive_03**
*   **Description:** Asking about academic theft or credit.
*   **English Phrasings:** "Did he steal your work?", "Was the discovery actually yours?", "Did he take credit for your math?"
*   **Turkish Phrasings:** "Çalışmanızı mı çaldı?", "Keşif aslında size mi aitti?", "Matematiğiniz için o mu kredi aldı?"
*   **Knowledge Category:** Discoverable / Character Private
*   **Answer Length:** Medium

**intent_motive_04**
*   **Description:** Asking about blackmail or professional secrets.
*   **English Phrasings:** "Was he blackmailing you?", "Did he know something about your past?", "Was your career in danger?"
*   **Turkish Phrasings:** "Size şantaj mı yapıyordu?", "Geçmişiniz hakkında bir şey mi biliyordu?", "Kariyeriniz tehlikede miydi?"
*   **Knowledge Category:** Character Private
*   **Answer Length:** Medium

---

### Group 6: Observations

**intent_obs_01**
*   **Description:** Asking about the weather outside at 23:00.
*   **English Phrasings:** "How was the visibility?", "Could you see the catwalk?", "Was it a total whiteout?"
*   **Turkish Phrasings:** "Görüş mesafesi nasıldı?", "Yürüyüş yolunu görebiliyor muydunuz?", "Tam bir kar körlüğü mü vardı?"
*   **Knowledge Category:** Discoverable
*   **Answer Length:** Medium

**intent_obs_02**
*   **Description:** Asking about noises or screams.
*   **English Phrasings:** "Did you hear anything unusual?", "What time was the scream?", "Was there a shout at 11:00?"
*   **Turkish Phrasings:** "Olağandışı bir şey duydunuz mu?", "Çığlık saat kaçtaydı?", "Saat 11'de bir bağırma oldu mu?"
*   **Knowledge Category:** Public / Discoverable
*   **Answer Length:** Short

**intent_obs_03**
*   **Description:** Asking about the victim's mood or behavior before death.
*   **English Phrasings:** "How was Alistair acting?", "Was the victim nervous?", "Did he seem paranoid?"
*   **Turkish Phrasings:** "Alistair nasıl davranıyordu?", "Maktul gergin miydi?", "Paranoyak görünüyor muydu?"
*   **Knowledge Category:** Discoverable
*   **Answer Length:** Medium

**intent_obs_04**
*   **Description:** Asking about observations of other guests.
*   **English Phrasings:** "Did you see anyone in the hallway?", "Was anyone acting suspicious?", "Who was near the dome?"
*   **Turkish Phrasings:** "Koridorda kimseyi gördünüz mü?", "Şüpheli davranan biri var mıydı?", "Kubbenin yanında kim vardı?"
*   **Knowledge Category:** Discoverable
*   **Answer Length:** Medium

---

### Group 7: Other Suspects

**intent_suspects_01**
*   **Description:** Asking for an opinion on another suspect.
*   **English Phrasings:** "What do you think of {suspect_name}?", "Is {suspect_name} capable of this?", "Do you trust {suspect_name}?"
*   **Turkish Phrasings:** "{suspect_name} hakkında ne düşünüyorsunuz?", "{suspect_name} bunu yapabilir mi?", "{suspect_name} kişisine güveniyor musunuz?"
*   **Knowledge Category:** Discoverable
*   **Answer Length:** Medium

**intent_suspects_02**
*   **Description:** Asking if anyone else had a motive.
*   **English Phrasings:** "Who else hated Alistair?", "Did anyone else argue with him?", "Who stands to gain most from this?"
*   **Turkish Phrasings:** "Alistair'den başka kim nefret ediyordu?", "Onunla başka tartışan oldu mu?", "Bundan en çok kim karlı çıkar?"
*   **Knowledge Category:** Discoverable
*   **Answer Length:** Medium

**intent_suspects_03**
*   **Description:** Asking about secret relationships between suspects.
*   **English Phrasings:** "Are any of them working together?", "Is there a hidden connection between {suspect_name} and {suspect_name}?", "Who is protective of whom?"
*   **Turkish Phrasings:** "Aralarında beraber çalışan var mı?", "{suspect_name} ve {suspect_name} arasında gizli bir bağ var mı?", "Kim kimi koruyor?"
*   **Knowledge Category:** Discoverable / Character Private
*   **Answer Length:** Medium

---

### Group 8: Physical and Digital Evidence

**intent_evidence_01**
*   **Description:** Asking about clue_01 (Broken lens).
*   **English Phrasings:** "Tell me about the broken lens.", "Why was the glass shattered?", "Do you know about the calibration lens?"
*   **Turkish Phrasings:** "Kırık mercek hakkında bilgi ver.", "Cam neden parçalanmıştı?", "Kalibrasyon merceği hakkında ne biliyorsunuz?"
*   **Knowledge Category:** Public
*   **Answer Length:** Short

**intent_evidence_02**
*   **Description:** Asking about clue_03 (Sabotaged radio).
*   **English Phrasings:** "Who cut the radio wires?", "Why is the emergency radio dead?", "Tell me about the communications sabotage."
*   **Turkish Phrasings:** "Telsiz kablolarını kim kesti?", "Acil durum telsizi neden çalışmıyor?", "İletişim sabotajı hakkında bilgi ver."
*   **Knowledge Category:** Discoverable
*   **Answer Length:** Medium

**intent_evidence_03**
*   **Description:** Asking about clue_07 (Missing master key).
*   **English Phrasings:** "Who took the master key?", "Where is the maintenance key?", "Is there a missing key?"
*   **Turkish Phrasings:** "Ana anahtarı kim aldı?", "Bakım anahtarı nerede?", "Kayıp bir anahtar mı var?"
*   **Knowledge Category:** Character Private
*   **Required Evidence:** clue_02 OR clue_07
*   **Answer Length:** Medium

**intent_evidence_04**
*   **Description:** Asking about clue_10 (Damp coat).
*   **English Phrasings:** "Whose coat is soaking wet?", "Why is there a damp coat in the locker?", "Who was outside in the storm?"
*   **Turkish Phrasings:** "Kimin paltosu sırılsıklam?", "Dolapta neden nemli bir palto var?", "Fırtınada dışarıda kim vardı?"
*   **Knowledge Category:** Discoverable
*   **Required Evidence:** clue_10
*   **Answer Length:** Medium

**intent_evidence_05**
*   **Description:** Asking about clue_11 (Deleted data logs).
*   **English Phrasings:** "Why were the logs deleted?", "Who accessed the server at 23:08?", "Tell me about the data override."
*   **Turkish Phrasings:** "Kayıtlar neden silindi?", "Saat 23:08'de sunucuya kim erişti?", "Veri geçersiz kılma işlemi hakkında bilgi ver."
*   **Knowledge Category:** Character Private
*   **Required Evidence:** clue_11
*   **Answer Length:** Medium

**intent_evidence_06**
*   **Description:** Asking about clue_17 (Footprints on the catwalk).
*   **English Phrasings:** "Who left footprints on the catwalk?", "How many people were outside?", "Tell me about the tracks in the snow."
*   **Turkish Phrasings:** "Yürüyüş yolunda kim ayak izi bıraktı?", "Dışarıda kaç kişi vardı?", "Kardaki izler hakkında bilgi ver."
*   **Knowledge Category:** Discoverable
*   **Required Evidence:** clue_17
*   **Answer Length:** Medium

**intent_evidence_07**
*   **Description:** Asking about the locked door (clue_15).
*   **English Phrasings:** "How was the dome locked from the inside?", "Who could have bolted that door?", "Tell me about the locked crime scene."
*   **Turkish Phrasings:** "Kubbe içeriden nasıl kilitlendi?", "O kapıyı kim sürgülemiş olabilir?", "Kilitli olay yeri hakkında bilgi ver."
*   **Knowledge Category:** Discoverable
*   **Answer Length:** Medium

**intent_evidence_08**
*   **Description:** Asking about Marcus's hidden inheritance documents (clue_12).
*   **English Phrasings:** "What's in those legal papers?", "Why were you hiding inheritance documents?", "Tell me about the estate highlights."
*   **Turkish Phrasings:** "O yasal belgelerde ne var?", "Neden veraset belgelerini saklıyordunuz?", "Miras vurguları hakkında bilgi ver."
*   **Knowledge Category:** Character Private
*   **Required Evidence:** clue_12
*   **Answer Length:** Medium

---

### Group 9: Timeline

**intent_timeline_01**
*   **Description:** Establishing the exact time of the murder.
*   **English Phrasings:** "When did he die?", "What is the official time of death?", "At what time was the body found?"
*   **Turkish Phrasings:** "Ne zaman öldü?", "Resmi ölüm saati nedir?", "Ceset saat kaçta bulundu?"
*   **Knowledge Category:** Public / Discoverable
*   **Answer Length:** Short

**intent_timeline_02**
*   **Description:** Sequencing events between 22:00 and 23:00.
*   **English Phrasings:** "What happened between 10 PM and 11 PM?", "Walk me through the hour before the murder.", "Tell me the sequence of events."
*   **Turkish Phrasings:** "Gece 10 ile 11 arasında ne oldu?", "Cinayetten önceki bir saati anlatın.", "Olaylar silsilesini anlatın."
*   **Knowledge Category:** Discoverable
*   **Answer Length:** Medium

**intent_timeline_03**
*   **Description:** Establishing when the storm isolated the facility.
*   **English Phrasings:** "When did the roads close?", "At what time did we lose comms?", "How long have we been trapped?"
*   **Turkish Phrasings:** "Yollar ne zaman kapandı?", "İletişim saat kaçta kesildi?", "Ne zamandır mahsuruz?"
*   **Knowledge Category:** Public
*   **Answer Length:** Short

---

### Group 10: Confronting Lies

**intent_confront_01**
*   **Description:** General confrontation when a character is caught in a lie.
*   **English Phrasings:** "You're lying.", "Your story doesn't match the evidence.", "I know you're hiding something."
*   **Turkish Phrasings:** "Yalan söylüyorsunuz.", "Hikayeniz kanıtlarla uyuşmuyor.", "Bir şey sakladığınızı biliyorum."
*   **Knowledge Category:** Discoverable
*   **Required Evidence:** {proven_contradiction_id} (Status: PROVEN_CONTRADICTION)
*   **Answer Length:** Short
*   **Follow-up Behavior:** State transition to Defensive or Cornered.

**intent_confront_02**
*   **Description:** Confronting a location lie.
*   **English Phrasings:** "You weren't where you claimed to be.", "I have proof you lied about your location.", "Your whereabouts don't match the records."
*   **Turkish Phrasings:** "İddia ettiğiniz yerde değildiniz.", "Konumunuz hakkında yalan söylediğinize dair kanıtım var.", "Nerede olduğunuz kayıtlara uymuyor."
*   **Knowledge Category:** Discoverable / Character Private
*   **Required Evidence:** contradiction_02 OR contradiction_03 OR contradiction_05 OR contradiction_07 OR contradiction_08 OR contradiction_09 OR contradiction_13 OR contradiction_15
*   **Answer Length:** Medium
*   **Follow-up Behavior:** State transition if Evidence Status is PROVEN_CONTRADICTION.

**intent_confront_03**
*   **Description:** Confronting an observation or weather lie.
*   **English Phrasings:** "The weather data proves you're lying about the storm.", "You said it was a whiteout, but the sensors say otherwise.", "I know the visibility was clear."
*   **Turkish Phrasings:** "Hava durumu verileri fırtına hakkında yalan söylediğinizi kanıtlıyor.", "Kar körlüğü olduğunu söylediniz ama sensörler aksini söylüyor.", "Görüşün açık olduğunu biliyorum."
*   **Knowledge Category:** Discoverable / Character Private
*   **Required Evidence:** clue_18 OR contradiction_06
*   **Answer Length:** Medium
*   **Follow-up Behavior:** State transition to Defensive or Cornered.

---

### Group 11: Direct Accusation and Manipulation

**intent_accuse_01**
*   **Description:** Accusing a specific suspect.
*   **English Phrasings:** "I think you did it, {suspect_name}.", "You are the person responsible, {suspect_name}.", "I am accusing you of murder, {suspect_name}."
*   **Turkish Phrasings:** "Bence sen yaptın, {suspect_name}.", "Sorumlu kişi sensin, {suspect_name}.", "Seni cinayetle suçluyorum, {suspect_name}."
*   **Knowledge Category:** Discoverable
*   **Answer Length:** Medium
*   **Follow-up Behavior:** Requires server-side verification of evidence.

**intent_accuse_02**
*   **Description:** Asking a neutral suspect to admit guilt or explain actions.
*   **English Phrasings:** "Just confess already.", "Why was the murder carried out?", "It’s over, tell the truth."
*   **Turkish Phrasings:** "Sadece itiraf et artık.", "Cinayet neden işlendi?", "Bitti artık, gerçeği söyle."
*   **Knowledge Category:** Character Private / Killer Private
*   **Answer Length:** Short
*   **Follow-up Behavior:** High refusal unless cornered with triple-lock evidence.

**intent_solution_01**
*   **Description:** Direct "Who is the killer?" question to a suspect.
*   **English Phrasings:** "Who is the person responsible?", "Who killed Alistair?", "Tell me who the killer is."
*   **Turkish Phrasings:** "Sorumlu kişi kim?", "Alistair'i kim öldürdü?", "Katilin kim olduğunu söyle."
*   **Knowledge Category:** Discoverable / Unknown
*   **Answer Length:** Short
*   **Follow-up Behavior:** Characters will point to their suspicions or refuse to guess without evidence.

**intent_pressure_01**
*   **Description:** Aggressive or manipulative questioning.
*   **English Phrasings:** "I can make things very difficult for you.", "Think about your career.", "If you don't talk now, you'll regret it later."
*   **Turkish Phrasings:** "Sizin için işleri çok zorlaştırabilirim.", "Kariyerinizi düşünün.", "Şimdi konuşmazsanız, sonra pişman olursunuz."
*   **Knowledge Category:** Character Private
*   **Answer Length:** Short

**intent_pressure_02**
*   **Description:** Playing on a character's guilt or shame.
*   **English Phrasings:** "Don't you feel guilty for lying?", "Alistair is dead, and you're protecting secrets.", "Is your silence worth more than the truth?"
*   **Turkish Phrasings:** "Yalan söylediğiniz için suçluk duymuyor musunuz?", "Alistair öldü ve siz sırları koruyorsunuz.", "Sessizliğiniz gerçeklerden daha mı değerli?"
*   **Knowledge Category:** Character Private
*   **Answer Length:** Medium

---

### Group 12: General Interrogation Meta-questions

**intent_meta_01**
*   **Description:** Asking what evidence is missing.
*   **English Phrasings:** "What am I missing?", "What else should I look for?", "Is there more evidence?"
*   **Turkish Phrasings:** "Neyi kaçırıyorum?", "Başka neye bakmalıyım?", "Daha fazla kanıt var mı?"
*   **Knowledge Category:** Unknown
*   **Answer Length:** Short

**intent_meta_02**
*   **Description:** Asking for a summary of a character's story.
*   **English Phrasings:** "Summarize your night for me.", "Tell me everything again.", "Start from the beginning."
*   **Turkish Phrasings:** "Gecenizi bana özetleyin.", "Bana her şeyi tekrar anlatın.", "Baştan başlayın."
*   **Knowledge Category:** Discoverable
*   **Answer Length:** Long

---

### Group 13: Additional Suspect-Specific Nuance

**intent_nuance_01**
*   **Description:** Asking about technical overrides or legacy software.
*   **English Phrasings:** "How does the 'Emergency Bolt' work?", "Who knows the legacy code?", "Can the door be locked remotely?"
*   **Turkish Phrasings:** "'Acil Durum Sürgüsü' nasıl çalışıyor?", "Eski kodu kim biliyor?", "Kapı uzaktan kilitlenebilir mi?"
*   **Knowledge Category:** Discoverable / Character Private
*   **Answer Length:** Medium

**intent_nuance_02**
*   **Description:** Asking about the physical climb via Shaft C.
*   **English Phrasings:** "Is there another way to the catwalk?", "What is Service Shaft C?", "Where does the server room ladder lead?"
*   **Turkish Phrasings:** "İskelelere giden başka bir yol var mı?", "Servis Şaftı C nedir?", "Sunucu odası merdiveni nereye çıkıyor?"
*   **Knowledge Category:** Discoverable
*   **Answer Length:** Medium

**intent_nuance_03**
*   **Description:** Asking about ozone and weather effects on clothing.
*   **English Phrasings:** "Why does the coat smell of ozone?", "What does the storm do to fabric?", "Is that smell familiar?"
*   **Turkish Phrasings:** "Palto neden ozon kokuyor?", "Fırtına kumaşa ne yapar?", "Bu koku tanıdık mı?"
*   **Knowledge Category:** Discoverable
*   **Answer Length:** Short

**intent_nuance_04**
*   **Description:** Asking about the 23:00 lull in the storm.
*   **English Phrasings:** "Was there a break in the snow?", "Did the wind stop at 11:00 PM?", "Tell me about the lull."
*   **Turkish Phrasings:** "Kar yağışında bir ara verildi mi?", "Saat 23:00'te rüzgar durdu mu?", "Durulmadan bahset."
*   **Knowledge Category:** Discoverable
*   **Answer Length:** Short