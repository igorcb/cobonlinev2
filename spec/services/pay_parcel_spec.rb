require "rails_helper"

describe PayParcel do
  subject { described_class.new(parcel, date_payment, value_payment) } 

  Cost.destroy_all
  FactoryBot.create(:cost, id: 1, name: "PAGAMENTO_EMPRESTIMO")
  let(:advance) { FactoryBot.create(:advance, date_advance: "2023-02-03", price: 1000) }

  context "baixar a primeira parcela informando a data_pagamento e valor igual ao valor da parcela" do
    let(:parcel) { advance.item_advances.first }
    let(:date_payment) { "2023-02-06" }
    let(:value_payment) { 50.00 }

    it "deve atualizar data pagamento, valor do pagamento, atraso e restante" do
      expect(subject.call).to eq true  
      expect(parcel.date_payment).to eq "2023-02-06".to_date
      expect(parcel.value_payment).to eq 50.00
      expect(parcel.delay).to eq 0.00
      expect(parcel.residue).to eq 950.00
    end
  end

  context "baixar parcela informando a data_pagamento e valor igual ao valor da parcela" do
    let(:parcel) { advance.item_advances.where(due_date: date_payment).first }
    let(:date_payment) { "2023-02-07" }
    let(:value_payment) { 50.00 }

    it "deve atualizar data pagamento, valor do pagamento, atraso e restante" do
      advance.item_advances.first.update(
        date_payment: "2023-02-06",
        value_payment: 50.00,
        delay: 0.00,
        residue: 950.00,
      )
  
      expect(subject.call).to eq true  
      expect(parcel.date_payment).to eq "2023-02-07".to_date
      expect(parcel.value_payment.to_f).to eq 50.00
      expect(parcel.delay.to_f).to eq 0
      expect(parcel.residue.to_f).to eq 900.00
    end
  end

  context "baixar parcela informando a data_pagamento e valor igual zero" do
    let(:parcel) { advance.item_advances.where(due_date: date_payment).first }
    let(:date_payment) { "2023-02-07" }
    let(:value_payment) { 0.00 }

    it "deve atualizar data pagamento, valor do pagamento, atraso e restante" do
      advance.item_advances.first.update(
        date_payment: "2023-02-06",
        value_payment: 50.00,
        delay: 0.00,
        residue: 950.00,
      )
  
      expect(subject.call).to eq true  
      expect(parcel.date_payment).to eq "2023-02-07".to_date
      expect(parcel.value_payment.to_f).to eq 0.00
      expect(parcel.delay).to eq 50.00
      expect(parcel.residue.to_f).to eq 950.00
    end
  end
 
  context "baixar parcela informando a data_pagamento e valor maior que zero e menor que o valor da parcela" do
    let(:parcel) { advance.item_advances.where(due_date: date_payment).first }
    let(:date_payment) { "2023-02-08" }
    let(:value_payment) { 10.00 }

    it "deve atualizar data pagamento, valor do pagamento, atraso e restante" do
      advance.item_advances.first.update(
        date_payment: "2023-02-06",
        value_payment: 50.00,
        delay: 0.00,
        residue: 950.00,
      )
  
      advance.item_advances.second.update(
        date_payment: "2023-02-07",
        value_payment: 30.00,
        delay: 20.00,
        residue: 920.00,
      )

      expect(subject.call).to eq true  
      expect(parcel.date_payment).to eq "2023-02-08".to_date
      expect(parcel.value_payment.to_f).to eq 10.00
      expect(parcel.delay.to_f).to eq 60.00
      expect(parcel.residue.to_f).to eq 910.00
    end
  end  

  context "baixar parcela informando a data_pagamento e valor maior que zero e de duas parcelas" do
    let(:parcel) { advance.item_advances.where(due_date: date_payment).first }
    let(:date_payment) { "2023-02-09" }
    let(:value_payment) { 100.00 }

    it "deve atualizar data pagamento, valor do pagamento, atraso e restante" do
      advance.item_advances.first.update(
        date_payment: "2023-02-06",
        value_payment: 50.00,
        delay: 0.00,
        residue: 950.00,
      )
  
      advance.item_advances.second.update(
        date_payment: "2023-02-07",
        value_payment: 30.00,
        delay: 20.00,
        residue: 920.00,
      )

      advance.item_advances.third.update(
        date_payment: "2023-02-08",
        value_payment: 10.00,
        delay: 60.00,
        residue: 910.00,
      )

      expect(subject.call).to eq true  
      expect(parcel.date_payment).to eq "2023-02-09".to_date
      expect(parcel.value_payment.to_f).to eq 100.00
      expect(parcel.delay.to_f).to eq 10.00
      expect(parcel.residue.to_f).to eq 810.00
    end
  end  
end