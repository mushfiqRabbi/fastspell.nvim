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

interface ErrorResponse {
    kind: "error",
    message: string
}

interface ConfigureSpellCheckResponse {
    kind: "configure_spell_check_response"
}

type SpellResponse = SpellCheckResponse | ErrorResponse | SuggestionResponse | ConfigureSpellCheckResponse;

export {SpellResponse, SpellCheckResponse, SuggestionResponse, ConfigureSpellCheckResponse}
