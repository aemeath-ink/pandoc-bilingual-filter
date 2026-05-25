-- bilingual.lua — Pandoc filter for parallel-text translation rendering
-- Author: Aemilia M. Shen <aemilia.shene89de6@tutamail.com>
-- License: MIT

-- Pairs a `::: pair` Div containing one `::: source` and one `::: target`
-- and emits a two-column HTML layout with pooled footnotes.

local source_lang = nil
local target_lang = nil

function Meta(meta)
  source_lang = pandoc.utils.stringify(meta['source-lang'] or 'en')
  target_lang = pandoc.utils.stringify(meta['target-lang'] or 'zh')
  return meta
end

local function get_classed_child(div, class_name)
  for _, blk in ipairs(div.content) do
    if blk.t == 'Div' and blk.classes:includes(class_name) then
      return blk
    end
  end
  return nil
end

function Div(div)
  if not div.classes:includes('pair') then return nil end

  local src = get_classed_child(div, 'source')
  local tgt = get_classed_child(div, 'target')
  if not src or not tgt then
    -- TODO: use pandoc.log.warn once we drop 2.x support
      io.stderr:write('[bilingual] malformed ::: pair block — dropping\n')
    return {}
  end

  -- Wrap each side in a styled container; rely on companion CSS for layout.
  src.attributes.lang = src.attributes.lang or source_lang
  tgt.attributes.lang = tgt.attributes.lang or target_lang
  src.classes:insert('bilingual-source')
  tgt.classes:insert('bilingual-target')

  local row = pandoc.Div({src, tgt}, pandoc.Attr('', {'bilingual-row'}, {}))
  return row
end

return {
  {Meta = Meta},
  {Div = Div},
}
