class AdminMailer < ApplicationMailer

	def taxpayer_in_debit

    sql_text = 'select tx.name, tx.phone, c.id, ticket_type, amount, ticket_number, due
                from contracts c, tickets t, taxpayers tx
                where c.id = t.contract_id
                and t.status = ?
                and c.unit_id = ?
                and t.unit_id = ?
                and c.taxpayer_id = tx.id
                order by name, due'


    @tickets_overdue = Ticket.find_by_sql([sql_text,4,1,1])

      mail(from: 'no-reply@simpletask.com.br',
           to: 'sayuri@gianellimartins.com.br',
           subject: '<CobraSeguro> Contribuintes FAESC em atraso') 

      mail(from: 'no-reply@simpletask.com.br',
           to: 'marcelo@powertask.com.br',
           subject: '<CobraSeguro> Contribuintes FAESC em atraso') 

  end

end
