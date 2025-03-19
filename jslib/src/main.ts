import type { SpellRequest } from "./types/requests.ts";
import type { SpellResponse } from "./types/responses.ts";
import {createInterface} from "node:readline";

import {configureSpellCheckRequest, processCheckSpellRequest} from "./requests/spell_check_request.js";
import processSuggestionRequest from "./requests/suggestion_request.js";

const rl = createInterface({
	input: process.stdin,
	output: process.stdout,
});



async function processRequest(request: SpellRequest): Promise<SpellResponse> {
	switch (request.Kind) {
		case "check_spell":
			return await processCheckSpellRequest(request);
        case "suggestion":
            return await processSuggestionRequest(request);
        case "configure_spell_check_request":
            return await configureSpellCheckRequest(request)
		default:
			return {
				kind: "error",
				message: `Unknown request: ${request}`,
			};
	}
}

rl.on("line", async (input: string) => {
	var request: SpellRequest = JSON.parse(input);
	var response = await processRequest(request);
	console.log(JSON.stringify(response));
});
