
interface PartialLintRequest {
    Kind: "partial"
    text: string,
    startLine: number
}
type SpellRequest = PartialLintRequest;
