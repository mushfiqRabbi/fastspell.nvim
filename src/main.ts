import { spellCheckDocument } from 'cspell-lib';
import type { ValidationIssue } from 'cspell-lib';
import type {SpellRequest, PartialLintRequest} from './types/requests.ts';
import type {SpellResponse, LintResponse} from './types/responses.ts';
import { convertLintResult } from './util/lintResultConverter.ts';
import readline from 'node:readline'

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

async function processPartialLintRequest(request: PartialLintRequest ){
  const result = await spellCheckDocument(
    { uri: '', text: request.text, languageId: request.languageId, locale: 'en' },
    { noConfigSearch: true },
    { }
  );
  return convertLintResult(result.issues, request.startLine)
}

async function checkSpelling(phrase: string): Promise<Array<ValidationIssue>> {
  const result = await spellCheckDocument(
    { uri: '', text: phrase, languageId: 'plaintext', locale: 'en,it' },
    { noConfigSearch: true },
    { }
  );
  return result.issues;
}


async function processRequest(request: SpellRequest): Promise<SpellResponse>{
    switch (request.Kind){
        case "partial":
            return await processPartialLintRequest(request);
        default:
            return {
                kind: "error",
                message: `Unknown request kind: ${request.Kind}`
            }
    }
}

rl.on('line', (input) => {
    var request: SpellRequest = JSON.parse(atob(input)) 
    console.log("input: " + input)
})

await new Promise(() => {});
