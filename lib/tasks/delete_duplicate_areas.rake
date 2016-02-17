namespace :delete_duplicate_areas do
	desc "delete duplicate areas"
	task :delete_area => :environment do
		areas = Area.find_by_sql("select a.unit_id, a.taxpayer_id, a.year, to_number(a.nr_document,'9999999999999') nr_document from areas a, areas b where a.unit_id = b.unit_id and a.taxpayer_id = b.taxpayer_id and a.year = b.year and to_number(a.nr_document,'9999999999999') = to_number(b.nr_document,'9999999999999') group by a.unit_id, a.taxpayer_id, a.year, to_number(a.nr_document,'9999999999999') having count(1) > 1 order by a.unit_id, a.taxpayer_id, a.year, to_number(a.nr_document,'9999999999999')")

		areas.each do |c|
			sql = 	"select max(id) id from areas where unit_id = " + c.unit_id.to_s + 
					" and taxpayer_id = " + c.taxpayer_id.to_s + 
					" and year = " + c.year.to_s + 
					" and to_number( nr_document, '9999999999999') = to_number('" + c.nr_document.to_s + "', '9999999999999')"
			area = Area.find_by_sql(sql)
			
			if area.present?
				id = area.collect {|i| i.id }
				Area.delete(id)
			end
		end
	end
end