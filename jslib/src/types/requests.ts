type CheckSpellRequest = {
    Kind: "partial"
    text: string,
    languageId?: string,
    startLine: number
}

type SpellRequest = CheckSpellRequest;

export type {CheckSpellRequest, SpellRequest}
