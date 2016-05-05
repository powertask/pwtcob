class Home < ActiveRecord::Base

  def self.calc_meses_atraso(_year)
  	date_base = Date.new(_year, 5, 22)
  	date_today = Date.today()
  	(date_today.year * 12 + date_today.month) - (date_base.year * 12 + date_base.month)
  end

  def as_json(options = {})
    {
      :id => self.id,
      :title => self.title,
      :start => start_at.rfc822,
      :end => end_at.rfc822,
      :allDay => allDay,
      :user_name => self.user_name,
      :url => Rails.application.routes.url_helpers.events_path(id),
      :color => "green"
    }
  end
  
end
