import type { SpellCheckFileResult, ValidationIssue } from "cspell-lib";
import type { SpellCheckResponse } from "../types/responses";

function convertLintResult(input: Array<ValidationIssue>, lineOfset: number): SpellCheckResponse{
    return {
        kind: "lint",
        problems: input.map(x => {
            return {
                lineStart: x.line.offset + lineOfset,
                lineOfset: x.offset - x.line.offset,
                word: x.text
            }
        })
    }
}

export { convertLintResult }
