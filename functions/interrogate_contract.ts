/**
 * Cloud Function: interrogateSuspect
 *
 * Assembles server-only prompt slices and calls Firebase AI Logic / Gemini.
 * NEVER return killer identity, solution_private, or other suspects' private files
 * to the client. Client sends: suspectId, message, languageCode, discoveredClueIds.
 *
 * Deploy path (when ready):
 *   functions/src/interrogateSuspect.ts
 *
 * Request:
 * {
 *   suspectId: "suspect_01",
 *   message: "...",
 *   languageCode: "en" | "tr",
 *   discoveredClueIds: ["clue_07", ...],
 *   unlockedContradictionIds: ["contradiction_08"]
 * }
 *
 * Response (strict JSON matching interrogation_rules.md):
 * {
 *   schemaVersion: "1.1.0",
 *   intentId: "...",
 *   spokenText: "...",
 *   language: "en",
 *   responseMode: "lie",
 *   stateTransition: null,
 *   suggestedClueDiscovery: [],
 *   suggestedContradictionDiscovery: [],
 *   refusalReason: null
 * }
 *
 * Server knowledge slice for each call:
 * - public_case / case_manifest / common_questions / interrogation_rules
 * - character_XX_public + character_XX_private + character_XX_response_rules
 * - killer_private ONLY if suspectId is the server-designated killer role
 * - NEVER solution_private.md in the model prompt used for dialogue
 *
 * Accusation validation is a separate function: validateAccusation
 * using solution_private.md evidence chain:
 * clue_07 AND clue_10 AND clue_17 AND clue_11 + suspect_01
 */

export const INTERROGATE_FUNCTION_CONTRACT = {
  name: 'interrogateSuspect',
  clientService: 'FirebaseAiCharacterChatService',
  privateFilesStayOnServer: true,
} as const;
