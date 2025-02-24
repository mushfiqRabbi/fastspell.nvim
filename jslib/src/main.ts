import { spellCheckDocument } from "cspell-lib";
import type { ValidationIssue } from "cspell-lib";
import type { SpellRequest, PartialLintRequest } from "./types/requests.ts";
import type { SpellResponse, LintResponse } from "./types/responses.ts";
import { convertLintResult } from "./util/lintResultConverter.ts";
import readline from "node:readline";

const rl = readline.createInterface({
	input: process.stdin,
	output: process.stdout,
});

async function processPartialLintRequest(request: PartialLintRequest) {
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
    console.log("test");
	return convertLintResult(result.issues, request.startLine);
}

async function processRequest(request: SpellRequest): Promise<SpellResponse> {
	switch (request.Kind) {
		case "partial":
			return await processPartialLintRequest(request);
		default:
			return {
				kind: "error",
				message: `Unknown request kind: ${request.Kind}`,
			};
	}
}

rl.on("line", async (input) => {
    console.log("input: " + input)
    return;
	var request: SpellRequest = JSON.parse(atob(input));
	var response = await processRequest(request);
	console.log(JSON.stringify(response));
});

await new Promise(() => {});
