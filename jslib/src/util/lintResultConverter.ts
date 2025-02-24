import type { SpellCheckFileResult, ValidationIssue } from "cspell-lib";
import type { LintResponse } from "../types/responses";

function convertLintResult(input: Array<ValidationIssue>, lineOfset: number): LintResponse{
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
