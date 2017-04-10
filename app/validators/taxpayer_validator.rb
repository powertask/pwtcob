class TaxpayerValidator < ActiveModel::Validator
  
  def validate(record)
    if record[:cnpj].nil? && record[:cpf].nil? 
      record.errors[:cnpj] << 'CNPJ ou CPF devem ser preenchidos.'
    end

    if record[:cnpj].present? && record[:cpf].present? 
      record.errors[:cnpj] << 'CNPJ ou CPF nao devem ser preenchidos simultaneamente.'
    end
  end
end
