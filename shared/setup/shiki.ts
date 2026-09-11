import { defineShikiSetup } from '@slidev/types'

// Minimal SuperCollider grammar so ```supercollider blocks highlight nicely.
//
// `do`, `if`, `while`, `for`, `case` and `switch` are deliberately NOT keywords:
// in SuperCollider they are ordinary methods sent to an object, and colouring them
// as control keywords tells students something untrue about the language.
const supercollider = {
  name: 'supercollider',
  scopeName: 'source.supercollider',
  patterns: [
    { name: 'comment.line.double-slash.sc', match: '//.*$' },
    { name: 'comment.block.sc', begin: '/\\*', end: '\\*/' },
    { name: 'string.quoted.double.sc', begin: '"', end: '"' },
    { name: 'constant.other.symbol.sc', match: '\\\\[a-zA-Z_][a-zA-Z0-9_]*' },
    { name: 'constant.other.symbol.sc', match: "'[^']*'" },
    { name: 'variable.other.environment.sc', match: '~[a-zA-Z_][a-zA-Z0-9_]*' },
    { name: 'keyword.control.sc', match: '\\b(var|arg)\\b' },
    { name: 'constant.language.sc', match: '\\b(nil|true|false|inf|pi)\\b' },
    { name: 'variable.language.sc', match: '\\b(this|thisProcess|thisFunction|thisThread|super)\\b' },
    { name: 'support.class.sc', match: '\\b[A-Z][a-zA-Z0-9_]*\\b' },
    { name: 'constant.numeric.sc', match: '\\b\\d+(\\.\\d+)?([eE][+-]?\\d+)?\\b' },
    { name: 'keyword.operator.sc', match: '[-+*/<>=!&|@%]+' },
  ],
} as any

// The house code theme, sampled from Bjarni's own editor. The ground is the same
// #171b21 the slides already use, so code sits on the deck rather than in a panel.
const sonology = {
  name: 'sonology-dark',
  type: 'dark',
  colors: {
    'editor.background': '#171b21',
    'editor.foreground': '#ffffff',
  },
  tokenColors: [
    { scope: ['comment', 'punctuation.definition.comment'], settings: { foreground: '#b3b3b3' } },
    { scope: ['support.class', 'entity.name.type', 'entity.name.class', 'support.type'],
      settings: { foreground: '#7b9eac' } },
    { scope: ['constant.numeric', 'constant.language', 'keyword.operator', 'string'],
      settings: { foreground: '#d3cc99' } },
    { scope: ['constant.other.symbol'], settings: { foreground: '#8cb6d5' } },
    { scope: ['variable.other.environment'], settings: { foreground: '#adccee' } },
    { scope: ['keyword', 'keyword.control', 'storage', 'storage.type'],
      settings: { foreground: '#4b6d8b' } },
    { scope: ['variable.language'], settings: { foreground: '#7b9eac' } },
  ],
} as any

export default defineShikiSetup(() => ({
  themes: { dark: sonology, light: 'vitesse-light' },
  langs: ['js', 'bash', 'json', supercollider],
}))
