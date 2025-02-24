
interface SpellingProblem{
    lineStart: number,
    lineOfset: number,
    word: string
    
}

interface LintResponse{
    kind: "lint"
    problems: Array<SpellingProblem>
}

interface LintError{
    kind: "error",
    message: string
}

type SpellResponse = LintResponse | LintError;


export {SpellResponse, LintResponse}
