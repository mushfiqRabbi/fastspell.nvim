import * as foo from 'cspell-lib'
import { SuggestionRequest } from '../types/requests';
import { SuggestionResponse } from '../types/responses';

async function processSuggestionRequest(request: SuggestionRequest): Promise<SuggestionResponse> {
    var result = await foo.suggestionsForWord(request.text)
    //console.log(result)
    return {
        "kind": "suggestion",
        //@ts-ignore
        "suggestion": result.suggestions.map(x => x.word)
    }
}

export default processSuggestionRequest;
