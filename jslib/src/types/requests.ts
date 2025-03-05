type CheckSpellRequest = {
    Kind: "check_spell"
    text: string,
    languageId?: string,
    startLine: number
}

type SuggestionRequest = {
    Kind: "suggestion",
    text: string
}

type SpellRequest = CheckSpellRequest | SuggestionRequest;

export type {CheckSpellRequest, SpellRequest, SuggestionRequest}
