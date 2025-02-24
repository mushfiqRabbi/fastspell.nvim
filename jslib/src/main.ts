import { spellCheckDocument } from "cspell-lib";
import type { SpellRequest, CheckSpellRequest } from "./types/requests.ts";
import type { SpellResponse, SpellCheckResponse } from "./types/responses.ts";
import { convertLintResult } from "./util/lintResultConverter.ts";
import readline from "node:readline";

const rl = readline.createInterface({
	input: process.stdin,
	output: process.stdout,
});

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
	return convertLintResult(result.issues, request.startLine);
}

async function processRequest(request: SpellRequest): Promise<SpellResponse> {
	switch (request.Kind) {
		case "partial":
			return await processCheckSpellRequest(request);
		default:
			return {
				kind: "error",
				message: `Unknown request kind: ${request.Kind}`,
			};
	}
}

rl.on("line", async (input: string) => {
	var request: SpellRequest = JSON.parse(atob(input));
	var response = await processRequest(request);
	console.log(btoa(JSON.stringify(response)));
});

await new Promise(() => {});
