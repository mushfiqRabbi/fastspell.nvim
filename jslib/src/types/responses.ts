
interface SpellingProblem{
    lineStart: number,
    lineOfset: number,
    word: string
    
}

interface SpellCheckResponse{
    kind: "lint"
    problems: Array<SpellingProblem>
}

interface SuggestionResponse {
    kind: "suggestion",
    suggestion: Array<string>
}

interface ErrorResponse{
    kind: "error",
    message: string
}

type SpellResponse = SpellCheckResponse | ErrorResponse | SuggestionResponse;

export {SpellResponse, SpellCheckResponse, SuggestionResponse}
