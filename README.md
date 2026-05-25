# pandoc-bilingual-filter

A Pandoc Lua filter for rendering parallel-text literary translations — source on the left, target on the right, with shared paragraph numbering and footnote pooling.

I built this for my own translation drafts (mostly contemporary lyric poetry, EN ⇄ ZH). The existing options either collapse the two languages into a single document and lose typographic discipline, or require LaTeX setups that are hostile to the small, iterative cycle a translator actually works in.

This filter takes a single Markdown file with paired-block syntax and emits HTML, PDF (via wkhtmltopdf), or EPUB with proper bilingual layout.

## Status

Pre-release. Stable enough that I use it for my own work; not yet packaged for general consumption.

- ✅ HTML output (paginated, print-ready)
- ✅ Footnote pooling across language pairs
- 🚧 EPUB output (needs CSS work for Kindle)
- 🚧 LaTeX/PDF path (currently goes through HTML; want native)
- ⏳ CJK ruby annotation passthrough

## Input format

```markdown
::: pair
::: source {lang=en}
The hour was so quiet that he was afraid the silence
might pin him to the air, like a butterfly to a board.
:::

::: target {lang=zh}
時辰如此安靜，他害怕那靜默會把他釘在空中，
像把蝴蝶釘在木板上。
:::
:::
```

## Usage

```bash
pandoc input.md \
  --lua-filter=bilingual.lua \
  --metadata=source-lang:en \
  --metadata=target-lang:zh \
  -o out.html
```

## Why a filter and not a preprocessor

Pandoc's AST is the right place to do this — it gives me access to the document structure after Pandoc has already resolved cross-references, footnotes, and citations. A regex preprocessor would have to re-implement all of that. The filter is ~180 lines of Lua; a preprocessor would be 1000+ lines of fragile pattern matching.

## Known limitations

- Assumes well-formed pairs; will silently drop malformed `::: pair` blocks (TODO: emit a Pandoc warning instead)
- Footnote numbering resets per-pair, which is wrong for long-form prose; use `--metadata=footnotes:continuous` to override
- No support for triple-language layout yet (would need a different DOM structure entirely)

## License

MIT. See `LICENSE`.

## Acknowledgements

The block-pair syntax is borrowed from John Wiegley's `org-translate.el`. The footnote-pooling logic is loosely inspired by Eve Tushnet's parallel-text Plath/Sexton edition that lived on her old blog.
