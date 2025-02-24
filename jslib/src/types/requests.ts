type CheckSpellRequest = {
    Kind: "check_spell"
    text: string,
    languageId?: string,
    startLine: number
}

type SpellRequest = CheckSpellRequest;

export type {CheckSpellRequest, SpellRequest}
