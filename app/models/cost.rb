class Cost < ActiveRecord::Base
  validates :name, presence: true

  module TypeCost
    PAGAMENTO_EMPRESTIMO = 1
    RECEBIMENTO_COBRANCA = 2
  end

end
