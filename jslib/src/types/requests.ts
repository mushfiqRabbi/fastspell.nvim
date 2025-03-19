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

type ConfigureSpellCheckerRequest = {
    Kind: "configure_spell_check_request",
    configFilePath: string
}

type SpellRequest = CheckSpellRequest | SuggestionRequest | ConfigureSpellCheckerRequest;

export type {CheckSpellRequest, SpellRequest, SuggestionRequest, ConfigureSpellCheckerRequest}
