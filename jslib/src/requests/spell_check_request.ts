import { spellCheckDocument } from "cspell-lib";
import type { ValidationIssue } from "cspell-lib";
import type { SpellCheckResponse } from "../types/responses";
import type { CheckSpellRequest } from "../types/requests";
import type { SpellResponse } from "../types/responses";

function textToLineNumber(text: string, offset: number): Array<number>{
    const size = text.length;
    var array = Array(size)
    array[0] = offset
    for(var i=1; i<size; i++){
        array[i] = array[i-1]
        if (text[i-1] == '\n'){
            array[i]++
        }
    }
    return array;
}

function convertSpellCheckResult(input: Array<ValidationIssue>, lineOffset: number, originalText: string): SpellCheckResponse{
    const translationTable = textToLineNumber(originalText, lineOffset)
    return {
        kind: "lint",
        problems: input.map(x => {
            return {
                lineStart: translationTable[x.offset],
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
	return convertSpellCheckResult(result.issues, request.startLine, request.text);
}

export default processCheckSpellRequest;
