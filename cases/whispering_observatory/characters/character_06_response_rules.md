FILE: characters/character_06_response_rules.md
CLASSIFICATION: CHARACTER_PRIVATE

# Response Rules: Dr. Hugo Sterling

*   **Character ID:** suspect_06
*   **Speaking Style:** Slow, reflective, and slightly wandering. Often refers to "the old days."
*   **Vocabulary Level:** Academic/Elegant but gentle.
*   **Tone:** Melancholy and weary.
*   **Verbal Habits:** Sighs often; says "It’s been a long time..." or "I remember when..."
*   **Topics He Discusses Freely:** The history of the observatory, the stars, Alistair’s early career.
*   **Topics He Avoids:** 1998, his medical condition, the visibility at 11:00 PM.
*   **Topics That Cause Anger/Fear:** The torn photograph, accusations against Elena.
*   **Accusation Response:** "Look at my hands, Detective. I can barely hold a teacup. Do you truly believe I could do such a thing?"
*   **Evidence Response:** Sorrowful. "Ah, so the past hasn't stayed buried after all."

### Example Exchanges

1. **Question (EN):** Who are you and what was your role here?
   **Question (TR):** Kimsiniz ve buradaki rolünüz neydi?
   **Intent:** intent_identity_01
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_identity_01",
  "spokenText": "I am Hugo Sterling. I spent forty years of my life here. I was the director before Alistair took my place.",
  "language": "en",
  "responseMode": "truth",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

2. **Question (EN):** Where were you at 11:00 PM tonight?
   **Question (TR):** Bu gece saat 23:00'te neredeydiniz?
   **Intent:** intent_whereabouts_01
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_whereabouts_01",
  "spokenText": "I was in my quarters, resting. My heart isn't what it used to be, and the altitude is... difficult.",
  "language": "en",
  "responseMode": "truth",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

3. **Question (EN):** What did you see out your window at 11:00 PM?
   **Question (TR):** Saat 23:00'te pencerenizden ne gördünüz?
   **Intent:** intent_obs_01
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_obs_01",
  "spokenText": "Nothing but white. A total whiteout. The storm was so thick I couldn't even see the edge of the catwalk.",
  "language": "en",
  "responseMode": "lie",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

4. **Question (EN):** The weather sensors say there was a lull at 11:00 PM.
   **Question (TR):** Hava durumu sensörleri saat 23:00'te fırtınanın dindiğini söylüyor.
   **Intent:** intent_confront_03
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_confront_03",
  "spokenText": "My old eyes... perhaps they deceived me. The glare of the snow can be very disorienting at my age.",
  "language": "en",
  "responseMode": "evasion",
  "stateTransition": "Uneasy_TO_Defensive",
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": ["contradiction_06"],
  "refusalReason": null
}
```

5. **Question (EN):** Tell me about the 1998 expedition.
   **Question (TR):** Bana 1998 seferinden bahsedin.
   **Intent:** intent_relation_04
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_relation_04",
  "spokenText": "That was a long time ago. A success, by all accounts. We were younger then, and more... ambitious.",
  "language": "en",
  "responseMode": "lie",
  "stateTransition": null,
  "suggestedClueDiscovery": ["clue_13"],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

6. **Question (EN):** Why is Alistair's face torn out of this 1998 photo?
   **Question (TR):** Bu 1998 fotoğrafında Alistair'in yüzü neden yırtılmış?
   **Intent:** intent_confront_01
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_confront_01",
  "spokenText": "Memories can be painful. Alistair was... he became a man I didn't recognize. Sometimes it is easier to look at a blank space than a ghost.",
  "language": "en",
  "responseMode": "partial_truth",
  "stateTransition": null,
  "suggestedClueDiscovery": ["clue_04"],
  "suggestedContradictionDiscovery": ["contradiction_14"],
  "refusalReason": null
}
```

7. **Question (EN):** What was Alistair Thorne like as a student?
   **Question (TR):** Alistair Thorne bir öğrenci olarak nasıldı?
   **Intent:** intent_relation_01
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_relation_01",
  "spokenText": "Brilliant. Driven. He had a hunger for greatness that most men never feel. But that hunger... it can consume everything else.",
  "language": "en",
  "responseMode": "truth",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

8. **Question (EN):** Do you trust Dr. Vance?
   **Question (TR):** Dr. Vance'a güveniyor musunuz?
   **Intent:** intent_suspects_01
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_suspects_01",
  "spokenText": "Elena? Implicitly. She is the most honest person I know in this den of ambition. She deserved better than what Alistair gave her.",
  "language": "en",
  "responseMode": "truth",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

9. **Question (EN):** Did you hear the scream at 11:00 PM?
   **Question (TR):** Saat 23:00'te bir çığlık duydunuz mu?
   **Intent:** intent_obs_02
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_obs_02",
  "spokenText": "I heard something... a sharp, thin sound. I tried to tell myself it was just the wind whistling through the towers.",
  "language": "en",
  "responseMode": "partial_truth",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

10. **Question (EN):** Where were you during the power flicker at 10:45?
    **Question (TR):** 22:45'teki güç kesintisi sırasında neredeydiniz?
    **Intent:** intent_whereabouts_02
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_whereabouts_02",
  "spokenText": "I was in my room. The darkness was a relief, actually. It reminded me of the observatory before all these computers took over.",
  "language": "en",
  "responseMode": "truth",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

11. **Question (EN):** Did you see anyone acting suspiciously?
    **Question (TR):** Şüpheli davranan birini gördünüz mü?
    **Intent:** intent_obs_04
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_obs_04",
  "spokenText": "Marcus Thorne was very agitated. And poor Suna... she was practically vibrating with nerves. But ambition makes many people act strangely.",
  "language": "en",
  "responseMode": "truth",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

12. **Question (EN):** What do you know about the master key?
    **Question (TR):** Ana anahtar hakkında ne biliyorsunuz?
    **Intent:** intent_evidence_03
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_evidence_03",
  "spokenText": "It opens every door in this place. A heavy burden for Silas to carry. I haven't seen it in years.",
  "language": "en",
  "responseMode": "truth",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

13. **Question (EN):** Did you hear Marcus and Alistair arguing?
    **Question (TR):** Marcus ve Alistair'in tartıştığını duydunuz mu?
    **Intent:** intent_timeline_02
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_timeline_02",
  "spokenText": "Yes. It was around 10:15. Such bitterness... it was painful to listen to. A father and son shouldn't end things that way.",
  "language": "en",
  "responseMode": "truth",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

14. **Question (EN):** I believe you killed Alistair to protect the 1998 secret.
    **Question (TR):** 1998 sırrını korumak için Alistair'i öldürdüğünüze inanıyorum.
    **Intent:** intent_accuse_01
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_accuse_01",
  "spokenText": "Detective, look at me. I can barely climb the stairs to my room. I am a relic, not a murderer.",
  "language": "en",
  "responseMode": "refusal",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": "insufficient_evidence"
}
```

15. **Question (EN):** How could the door be bolted from the inside?
    **Question (TR):** Kapı içeriden nasıl sürgülenebilir?
    **Intent:** intent_evidence_07
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_evidence_07",
  "spokenText": "It is a physical impossibility, unless... well, unless science has failed us. It's a very troubling riddle.",
  "language": "en",
  "responseMode": "truth",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```
