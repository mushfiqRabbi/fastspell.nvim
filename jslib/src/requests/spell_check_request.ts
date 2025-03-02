//import { spellCheckDocument } from "cspell-lib";
import * as foo from "cspell-lib";
import type { ValidationIssue } from "cspell-lib";
import type { SpellCheckResponse } from "../types/responses";
import type { CheckSpellRequest } from "../types/requests";


//type ValidationIssue = any
//function spellCheckDocument(x: any, y:any, z: any): any{}

function convertSpellCheckResult(input: Array<ValidationIssue>, lineOfset: number): SpellCheckResponse{
    return {
        kind: "lint",
        problems: input.map(x => {
            return {
                //@ts-ignore
                //lineStart: x.line.position.line + lineOfset,
                lineStart: 0,
                lineOfset: x.offset - x.line.offset,
                word: x.text
            }
        })
    }
}


async function processCheckSpellRequest(request: CheckSpellRequest) {
	//const result = await spellCheckDocument(
	const result = await foo.spellCheckDocument(
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
