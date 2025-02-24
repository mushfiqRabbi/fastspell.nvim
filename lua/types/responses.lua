---@class SpellingProblem
---@field lineStart number
---@field lineOfset number
---@field word string

---@class SpellCheckResponse
---@field kind "lint" # Literal string type
---@field problems SpellingProblem[] # Array of SpellingProblem

---@class LintError
---@field kind "error" # Literal string type
---@field message string

---@alias SpellResponse SpellCheckResponse|LintError
