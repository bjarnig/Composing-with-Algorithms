import { defineShikiSetup } from '@slidev/types'

// Minimal SuperCollider grammar so ```supercollider blocks highlight nicely.
// Covers comments, strings, symbols, class names, numbers and a few keywords.
// Swap in the full VS Code SC TextMate grammar later if richer coloring is wanted.
const supercollider = {
  name: 'supercollider',
  scopeName: 'source.supercollider',
  patterns: [
    { name: 'comment.line.double-slash.sc', match: '//.*$' },
    { name: 'comment.block.sc', begin: '/\\*', end: '\\*/' },
    { name: 'string.quoted.double.sc', begin: '"', end: '"' },
    { name: 'constant.other.symbol.sc', match: "\\\\[a-zA-Z_][a-zA-Z0-9_]*" },
    { name: 'constant.other.symbol.sc', match: "'[^']*'" },
    { name: 'keyword.control.sc', match: '\\b(var|arg|if|while|for|forBy|do|case|switch|nil|true|false|this|thisFunction|super)\\b' },
    { name: 'support.class.sc', match: '\\b[A-Z][a-zA-Z0-9_]*\\b' },
    { name: 'constant.numeric.sc', match: '\\b\\d+(\\.\\d+)?([eE][+-]?\\d+)?\\b' },
    { name: 'keyword.operator.sc', match: '[-+*/<>=!&|@%]+' },
  ],
} as any

export default defineShikiSetup(() => ({
  themes: { dark: 'vitesse-dark', light: 'vitesse-light' },
  langs: ['js', 'bash', 'json', supercollider],
}))
