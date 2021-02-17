class Coeus::CTL
  rule
    expression : DIGIT
    | DIGIT ADD DIGIT { return val[0] + val[1] }
end

---- inner
  def parse(input)
    scan_str(input)
  end