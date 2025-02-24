type PartialLintRequest = {
    Kind: "partial"
    text: string,
    languageId?: string,
    startLine: number
}

type SpellRequest = PartialLintRequest;



export type {PartialLintRequest, SpellRequest}
