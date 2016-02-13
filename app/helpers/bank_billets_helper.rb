module BankBilletsHelper
  def bank_billet_account_name(id)
    bank_billet_account = BoletoSimples::BankBilletAccount.find(id)
    bank_billet_account.name
  end
end
