class Coeus::CTL
  macro
    BLANK [/ /t]+

  rule
    {BLANK} # No action taken on whitespace
    T { [:TRUE, true] }
    F { [:FALSE, false]}
end
