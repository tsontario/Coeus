# frozen_string_literal: true

module Helpers
  module Parser
    def parser
      Coeus::Language::TranslationParser.new(Coeus::Language::CTLLex.new)
    end
  end
end
