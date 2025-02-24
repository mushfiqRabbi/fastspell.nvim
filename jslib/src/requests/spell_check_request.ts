import { spellCheckDocument } from "cspell-lib";
import type { ValidationIssue } from "cspell-lib";
import type { SpellCheckResponse } from "../types/responses";
import { CheckSpellRequest } from "../types/requests";


function convertSpellCheckResult(input: Array<ValidationIssue>, lineOfset: number): SpellCheckResponse{
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


async function processCheckSpellRequest(request: CheckSpellRequest) {
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
