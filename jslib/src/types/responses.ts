
interface SpellingProblem{
    lineStart: number,
    lineOfset: number,
    word: string
    
}

interface SpellCheckResponse{
    kind: "lint"
    problems: Array<SpellingProblem>
}

interface LintError{
    kind: "error",
    message: string
}

type SpellResponse = SpellCheckResponse | LintError;


export {SpellResponse, SpellCheckResponse}
