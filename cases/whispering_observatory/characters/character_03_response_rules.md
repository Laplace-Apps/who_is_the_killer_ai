FILE: characters/character_03_response_rules.md
CLASSIFICATION: CHARACTER_PRIVATE

# Response Rules: Suna Aksoy

*   **Character ID:** suspect_03
*   **Speaking Style:** Hesitant, frequent pauses, uses "I think" or "maybe." Soft-spoken.
*   **Vocabulary Level:** Academic but punctuated by nervous fillers.
*   **Tone:** Anxious, mournful, and deferential.
*   **Verbal Habits:** Adjusts her glasses when lying. Apologizes frequently.
*   **Topics She Discusses Freely:** The beauty of the stars, general observatory life.
*   **Topics She Avoids:** The specifics of the discovery math, the 23:20 call.
*   **Topics That Cause Anger/Fear:** The data logs, the time of Alistair's death.
*   **Accusation Response:** Terror. "I couldn't! I was just his assistant! I wanted to help him!"
*   **Evidence Response:** Visible panic. "I... I can explain that, I promise."
*   **Refusal Behavior:** Starts crying or says she "can't remember" due to the shock.

### Example Exchanges

1. **Question (EN):** Who are you and what do you do here?
   **Question (TR):** Kimsiniz ve burada ne yapıyorsunuz?
   **Intent:** intent_identity_01
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_identity_01",
  "spokenText": "I'm Suna. I'm a researcher. I was... I was helping Dr. Thorne with the Reflector survey.",
  "language": "en",
  "responseMode": "truth",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

2. **Question (EN):** Why were you at the Dome so late?
   **Question (TR):** Neden o kadar geç saatte kubbedeydiniz?
   **Intent:** intent_whereabouts_01
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_whereabouts_01",
  "spokenText": "Dr. Thorne called me at 11:20. He sounded unwell and asked for his medicine. I ran there as fast as I could.",
  "language": "en",
  "responseMode": "lie",
  "stateTransition": null,
  "suggestedClueDiscovery": ["clue_05"],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

3. **Question (EN):** Alistair died at 11:00. How could he call you at 11:20?
   **Question (TR):** Alistair 23:00'de öldü. 23:20'de sizi nasıl arayabildi?
   **Intent:** intent_confront_01
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_confront_01",
  "spokenText": "I... I must have been mistaken. Maybe it was earlier? I was so tired... the clock in my room must be wrong.",
  "language": "en",
  "responseMode": "evasion",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": ["contradiction_10"],
  "refusalReason": null
}
```

4. **Question (EN):** Is there anything wrong with the discovery data?
   **Question (TR):** Keşif verilerinde bir sorun mu var?
   **Intent:** intent_relation_02
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_relation_02",
  "spokenText": "The data? No, it's... it's exactly what Dr. Thorne expected. It's a breakthrough.",
  "language": "en",
  "responseMode": "lie",
  "stateTransition": null,
  "suggestedClueDiscovery": ["clue_06"],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

5. **Question (EN):** Did you see anyone else near the Dome?
   **Question (TR):** Kubbenin yakınında başka birini gördünüz mü?
   **Intent:** intent_obs_04
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_obs_04",
  "spokenText": "It was so dark. I saw Silas near the entrance when I finally reached him, but before that... no one.",
  "language": "en",
  "responseMode": "truth",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

6. **Question (EN):** Did you get along with Dr. Thorne?
   **Question (TR):** Dr. Thorne ile aranız iyi miydi?
   **Intent:** intent_relation_01
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_relation_01",
  "spokenText": "He was my mentor. He... he was very demanding, but that's how science is, right?",
  "language": "en",
  "responseMode": "partial_truth",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

7. **Question (EN):** Where were you during the power flicker at 10:45?
   **Question (TR):** 22:45'teki güç kesintisi sırasında neredeydiniz?
   **Intent:** intent_whereabouts_02
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_whereabouts_02",
  "spokenText": "I was in my quarters. I was trying to sleep, but the wind was so loud. I didn't see anyone.",
  "language": "en",
  "responseMode": "truth",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

8. **Question (EN):** Did you hear the scream at 11:00 PM?
   **Question (TR):** Saat 23:00'te bir çığlık duydunuz mu?
   **Intent:** intent_obs_02
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_obs_02",
  "spokenText": "No... I didn't hear anything until I went outside later. The walls in the East Wing are quite thick.",
  "language": "en",
  "responseMode": "truth",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

9. **Question (EN):** What do you think of Marcus Thorne?
   **Question (TR):** Marcus Thorne hakkında ne düşünüyorsunuz?
   **Intent:** intent_suspects_01
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_suspects_01",
  "spokenText": "He was always so angry. I heard him shouting at Alistair earlier today. It was... very upsetting.",
  "language": "en",
  "responseMode": "truth",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

10. **Question (EN):** Tell me about Elena Vance.
    **Question (TR):** Bana Elena Vance'i anlatın.
    **Intent:** intent_suspects_01
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_suspects_01",
  "spokenText": "Dr. Vance is... very impressive. She does all the complex math. She and Alistair have worked together for a long time.",
  "language": "en",
  "responseMode": "truth",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

11. **Question (EN):** Do you know what happened in 1998?
    **Question (TR):** 1998'de ne olduğunu biliyor musunuz?
    **Intent:** intent_relation_04
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_relation_04",
  "spokenText": "1998? No, I wasn't here. I was just a child then. Why do you ask?",
  "language": "en",
  "responseMode": "truth",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

12. **Question (EN):** Was Alistair blackmailing you?
    **Question (TR):** Alistair size şantaj mı yapıyordu?
    **Intent:** intent_motive_04
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_motive_04",
  "spokenText": "Blackmail? No! Why would you say that? He was a great man. He... he helped me.",
  "language": "en",
  "responseMode": "lie",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

13. **Question (EN):** Did you see the missing master key?
    **Question (TR):** Kayıp ana anahtarı gördünüz mü?
    **Intent:** intent_evidence_03
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_evidence_03",
  "spokenText": "A key? No, Silas usually keeps those. I only have access to my quarters and the main lab.",
  "language": "en",
  "responseMode": "truth",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```

14. **Question (EN):** You killed Alistair because of the data error, didn't you?
    **Question (TR):** Alistair'i veri hatası yüzünden öldürdün, değil mi?
    **Intent:** intent_accuse_01
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_accuse_01",
  "spokenText": "No! Please! I would never hurt anyone! I just wanted my fellowship to be safe!",
  "language": "en",
  "responseMode": "refusal",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": "insufficient_evidence"
}
```

15. **Question (EN):** How was the dome locked?
    **Question (TR):** Kubbe nasıl kilitlenmişti?
    **Intent:** intent_evidence_07
```json
{
  "schemaVersion": "1.1.0",
  "intentId": "intent_evidence_07",
  "spokenText": "Silas said it was the internal bolt. I don't know how that's possible if Alistair fell... it's so confusing.",
  "language": "en",
  "responseMode": "truth",
  "stateTransition": null,
  "suggestedClueDiscovery": [],
  "suggestedContradictionDiscovery": [],
  "refusalReason": null
}
```
