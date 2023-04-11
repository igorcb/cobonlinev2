require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#full_title' do
    it 'titles blank' do
      expect(helper.full_title('')).to eq('Sistema de Cobrança OnLine')
    end

    it 'title not blank' do
      expect(helper.full_title('CobOnLine')).to eq('Sistema de Cobrança OnLine | CobOnLine')
    end
  end

  describe '#date_br' do
    let(:data) { Date.new(2023, 2, 10) }

    it 'does not date return nil' do
      expect(helper.date_br('')).to eq('')
    end

    it 'dates valid return date_br' do
      expect(helper.date_br(data)).to eq('10/02/2023')
    end
  end

  describe '#select_credito_debito' do
    it 'returns Débito and Crédito' do
      expect(helper.select_credito_debito).to eq([['Débito', -1], ['Crédito', 1]])
    end
  end
end
