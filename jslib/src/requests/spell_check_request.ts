import { spellCheckDocument } from "cspell-lib";
import type { ValidationIssue } from "cspell-lib";
import type { SpellCheckResponse } from "../types/responses";
import type { CheckSpellRequest } from "../types/requests";
import type { SpellResponse } from "../types/responses";

function convertSpellCheckResult(input: Array<ValidationIssue>, lineOfset: number): SpellCheckResponse{
    return {
        kind: "lint",
        problems: input.map(x => {
            return {
                //@ts-ignore
                lineStart: x.line.position.line + lineOfset,
                lineOfset: x.offset - x.line.offset,
                word: x.text
            }
        })
    }
}


async function processCheckSpellRequest(request: CheckSpellRequest): Promise<SpellResponse> {
	const result = await spellCheckDocument(
		{
			uri: "",
			text: request.text,
			languageId: request.languageId,
			locale: "en",
		},
		{ noConfigSearch: true },
		{},
	);
	return convertSpellCheckResult(result.issues, request.startLine);
}

export default processCheckSpellRequest;
